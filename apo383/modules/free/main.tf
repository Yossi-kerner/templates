terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "suffix" {
  type    = string
  default = "a"
}

variable "owner" {
  type    = string
  default = "qa"
}

# Fake static credentials: every check here is plan-only, and infracost prices
# from the plan file rather than from the AWS API.
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "AKIAIOSFODNN7EXAMPLE"
  secret_key                  = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}

# Supported by infracost, priced at $0 without a usage file, so the project shows
# up in the breakdown with a zero diff.
resource "aws_s3_bucket" "qa" {
  bucket = "apo383-qa-free-${var.suffix}"

  tags = {
    Owner  = var.owner
    Ticket = "APO-383"
  }
}

resource "aws_iam_role" "qa" {
  name = "apo383-qa-free-${var.suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Owner  = var.owner
    Ticket = "APO-383"
  }
}
