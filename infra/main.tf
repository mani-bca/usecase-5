
module "lambda_iam" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/iam?ref=main"

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

module "s3_bucket_original" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/s3?ref=main"

  bucket_name         = var.source_bucket_name
  tags                = var.tags
  enable_notification = true
  lambda_function_arn = module.lambda_resize.function_arn
  lambda_permission   = module.lambda_resize.s3_permission
}

module "s3_bucket_resized" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/s3?ref=main"

  bucket_name = var.destination_bucket_name
  tags        = var.tags
}

module "sns_topic" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/sns?ref=main"

  topic_name       = var.sns_topic_name
  email_addresses  = var.notification_emails
  tags             = var.tags
}

module "lambda_resize" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/lambda?ref=main"

  function_name         = var.lambda_function_name
  lambda_source_dir     = "${path.module}/lambda_package"
  handler               = "resize_image.handler"
  runtime               = "nodejs18.x"
  timeout               = 60
  memory_size           = 256
  role_arn              = module.lambda_iam.role_arn
  # enable_s3_trigger     = true
  # s3_bucket_arn         = module.s3_bucket_original.bucket_arn
  
  environment_variables = {
    DESTINATION_BUCKET = module.s3_bucket_resized.bucket_id
    SNS_TOPIC_ARN      = module.sns_topic.topic_arn
    RESIZE_WIDTH       = var.resize_width
  }
  tags = var.tags
}
