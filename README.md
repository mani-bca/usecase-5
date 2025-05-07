# AWS Serverless Image Resizing Solutionev

This Terraform project creates an automated image resizing solution in AWS using serverless technologies:

- **S3** for storage of original and resized images
- **Lambda** for image processing
- **SNS** for email notifications

## Architecture

1. User uploads an image to the source S3 bucket
2. This triggers a Lambda function that resizes the image
3. The Lambda function saves the resized image to a destination S3 bucket
4. The Lambda function sends a notification via SNS
5. SNS delivers an email notification

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.0.0+)
- Node.js and NPM (for local development of Lambda function)

## Setup and Deployment

1. Install the required NPM packages for the Lambda function:

```bash
cd src
npm init -y
npm install aws-sdk sharp --save
```

2. Update `terraform.tfvars` with your specific values:

```hcl
aws_region = "us-east-1"
source_bucket_name = "your-source-bucket-name"
destination_bucket_name = "your-destination-bucket-name"
notification_emails = ["your-email@example.com"]
# ... other variables
```

3. Initialize, plan, and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Testing the Solution

1. Upload an image to the source S3 bucket:

```bash
aws s3 cp test-image.jpg s3://your-source-bucket-name/
```

2. Check the destination S3 bucket for the resized image:

```bash
aws s3 ls s3://your-destination-bucket-name/
```

3. Verify you received an email notification.

## Customization

- Modify `src/resize_image.js` to implement different image processing logic
- Update `terraform.tfvars` to change configuration parameters
- Add more subscribers to the SNS topic in `notification_emails` variable

## Cleanup

To remove all resources created by this project:

```bash
terraform destroy
```

## Directory Structure

```
.
├── main.tf               # Root module configuration
├── variables.tf          # Root variable definitions
├── outputs.tf            # Root output definitions
├── terraform.tfvars      # Variable values
├── src/
│   └── resize_image.js   # Lambda function code
└── modules/
    ├── s3/               # S3 bucket module
    ├── lambda/           # Lambda function module
    └── sns/              # SNS topic module
```
