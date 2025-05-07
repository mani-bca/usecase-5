aws_region  = "us-east-1"
tags = {
  Project     = "Image-Resizing"
  Environment = "dev"
  ManagedBy   = "Terraform"
}
source_bucket_name     = "source-bucketd-uniqued"
destination_bucket_name = "destination-bucketd-uniqued"
sns_topic_name         = "image-resize-notification"
notification_emails    = ["manidevops2021@gmail.com"]
lambda_function_name   = "image-resize-function"
resize_width           = 800
