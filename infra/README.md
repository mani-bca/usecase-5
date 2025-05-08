<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_iam"></a> [lambda\_iam](#module\_lambda\_iam) | git::https://github.com/mani-bca/set-aws-infra.git//modules/iam | main |
| <a name="module_lambda_resize"></a> [lambda\_resize](#module\_lambda\_resize) | git::https://github.com/mani-bca/set-aws-infra.git//modules/lambda | main |
| <a name="module_s3_bucket_original"></a> [s3\_bucket\_original](#module\_s3\_bucket\_original) | git::https://github.com/mani-bca/set-aws-infra.git//modules/s3 | main |
| <a name="module_s3_bucket_resized"></a> [s3\_bucket\_resized](#module\_s3\_bucket\_resized) | git::https://github.com/mani-bca/set-aws-infra.git//modules/s3 | main |
| <a name="module_sns_topic"></a> [sns\_topic](#module\_sns\_topic) | git::https://github.com/mani-bca/set-aws-infra.git//modules/sns | main |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_destination_bucket_name"></a> [destination\_bucket\_name](#input\_destination\_bucket\_name) | Name of the S3 bucket for resized images | `string` | n/a | yes |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of the Lambda function | `string` | n/a | yes |
| <a name="input_notification_emails"></a> [notification\_emails](#input\_notification\_emails) | List of email addresses to receive notifications | `list(string)` | n/a | yes |
| <a name="input_resize_width"></a> [resize\_width](#input\_resize\_width) | Width to resize images to (in pixels) | `number` | `800` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name of the SNS topic | `string` | n/a | yes |
| <a name="input_source_bucket_name"></a> [source\_bucket\_name](#input\_source\_bucket\_name) | Name of the S3 bucket for original images | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_bucket_name"></a> [destination\_bucket\_name](#output\_destination\_bucket\_name) | Name of the destination S3 bucket |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Name of the Lambda function |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic |
| <a name="output_source_bucket_name"></a> [source\_bucket\_name](#output\_source\_bucket\_name) | Name of the source S3 bucket |
<!-- END_TF_DOCS -->