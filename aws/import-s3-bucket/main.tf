# This block configures Terraform's settings, including the required version.
terraform {
  # This line enforces that the configuration can only be run with Terraform v1.4.5.
  required_version = "1.4.5"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider with a specific region.
# Ensure your environment is configured with AWS credentials.
provider "aws" {
  region = "us-east-1"
}

# This resource generates a random, two-word pet name like "proper-wombat".
resource "random_pet" "bucket_name" {
  length = 2
}

# This resource creates an S3 bucket in your AWS account. 🪣
resource "aws_s3_bucket" "app_bucket" {
  # The bucket name is set to the ID of the 'random_pet' resource.
  # Using random_pet helps ensure the global uniqueness required for S3 bucket names.
  bucket = random_pet.bucket_name.id
}

# This output will display the name of the created bucket after you apply the plan.
output "s3_bucket_name" {
  description = "The globally unique name of the created S3 bucket."
  value       = aws_s3_bucket.app_bucket.id
}
