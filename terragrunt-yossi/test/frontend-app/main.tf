# main.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # Optional: Set the backend configuration if needed (e.g., for remote state)
}

provider "aws" {
  region = "us-east-1"  # Set your AWS region here
}

module "s3_bucket" {
  # version = "2.15.0"
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "my-unique-s3-bucket-name-yossi-4"  # Change to a globally unique name
}
