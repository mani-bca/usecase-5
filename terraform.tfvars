aws_region             = "us-east-1"
source_bucket_name     = "image-resizing-source-bucket"
destination_bucket_name = "image-resizing-destination-bucket"
sns_topic_name         = "image-resize-notification"
notification_emails    = ["user@example.com"]
lambda_function_name   = "image-resize-function"
resize_width           = 800

tags = {
  Project     = "Image Resizing Service"
  Environment = "Production"
  ManagedBy   = "Terraform"
}