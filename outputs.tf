output "source_bucket_name" {
  description = "Name of the source S3 bucket"
  value       = module.s3_bucket_original.bucket_id
}

output "destination_bucket_name" {
  description = "Name of the destination S3 bucket"
  value       = module.s3_bucket_resized.bucket_id
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda_resize.function_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = module.sns_topic.topic_arn
}