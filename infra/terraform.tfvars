aws_region  = "us-east-1"
tags = {
  Project     = "Image-Resizing"
  Environment = "dev"
  ManagedBy   = "Terraform"
}
source_bucket_name     = "source-bucket-unique"
destination_bucket_name = "destination-bucket-unique"
sns_topic_name         = "image-resize-notification"
notification_emails    = ["manidevops201@gmai.com"]
lambda_function_name   = "image-resize-function"
resize_width           = 800
