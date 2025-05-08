provider "aws" {
  region = var.aws_region
}

# IAM role and permissions for Lambda
module "lambda_iam" {
  source = "./modules/iam"

  role_name           = "${var.lambda_function_name}-role"
  policy_name         = "${var.lambda_function_name}-policy"
  policy_description  = "IAM policy for Lambda function ${var.lambda_function_name}"
  service_principal   = "lambda.amazonaws.com"
  enable_s3_trigger   = true
  function_name       = var.lambda_function_name
  s3_bucket_arn       = module.s3_bucket_original.bucket_arn
  
  policy_statements = [
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:logs:*:*:*"
    },
    {
      Action = [
        "s3:GetObject"
      ]
      Effect   = "Allow"
      Resource = "${module.s3_bucket_original.bucket_arn}/*"
    },
    {
      Action = [
        "s3:PutObject"
      ]
      Effect   = "Allow"
      Resource = "${module.s3_bucket_resized.bucket_arn}/*"
    },
    {
      Action = [
        "sns:Publish"
      ]
      Effect   = "Allow"
      Resource = module.sns_topic.topic_arn
    }
  ]

  tags = var.tags
}

# S3 Bucket for original images
module "s3_bucket_original" {
  source = "./modules/s3"

  bucket_name         = var.source_bucket_name
  tags                = var.tags
  enable_notification = true
  lambda_function_arn = module.lambda_resize.function_arn
  lambda_permission   = module.lambda_iam.s3_permission
}

# S3 Bucket for resized images
module "s3_bucket_resized" {
  source = "./modules/s3"

  bucket_name = var.destination_bucket_name
  tags        = var.tags
}

# SNS Topic for notifications
module "sns_topic" {
  source = "./modules/sns"

  topic_name      = var.sns_topic_name
  email_addresses = var.notification_emails
  tags            = var.tags
}

# Lambda function for image resizing
module "lambda_resize" {
  source = "./modules/lambda"

  function_name         = var.lambda_function_name
  lambda_source_dir     = "${path.module}/lambda_package"
  handler               = "resize_image.handler"
  runtime               = "nodejs18.x"
  timeout               = 60
  memory_size           = 256
  role_arn              = module.lambda_iam.role_arn
  
  environment_variables = {
    DESTINATION_BUCKET = module.s3_bucket_resized.bucket_id
    SNS_TOPIC_ARN      = module.sns_topic.topic_arn
    RESIZE_WIDTH       = var.resize_width
  }

  tags = var.tags
}