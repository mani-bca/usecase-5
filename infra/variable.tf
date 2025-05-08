variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "source_bucket_name" {
  description = "Name of the S3 bucket for original images"
  type        = string
}

variable "destination_bucket_name" {
  description = "Name of the S3 bucket for resized images"
  type        = string
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "notification_emails" {
  description = "List of email addresses to receive notifications"
  type        = list(string)
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "resize_width" {
  description = "Width to resize images to (in pixels)"
  type        = number
  default     = 800
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "tagss" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}