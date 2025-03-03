# main.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Define the remote module source
  module "s3_bucket" {
    source = "terraform-aws-modules/s3-bucket/aws"
    bucket = "my-unique-s3-bucket-name-yossi" # Change to a globally unique name
    acl    = "private"
  }
}

provider "aws" {
  region = "us-east-1" # You can change this to your preferred region
}

output "bucket_name" {
  value = module.s3_bucket.bucket
}
