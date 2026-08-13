terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
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

# IAM resources are free in infracost's pricing model, so the project ends up with
# an empty diff and infracost prints "1 project has no cost estimate change."
# rather than a cost table. That is the shape APO-383 regressed on.
resource "aws_iam_role" "qa" {
  name = "apo383-qa-nocost"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Owner  = "qa-a1"
    Ticket = "APO-383"
  }
}

resource "aws_iam_policy" "qa" {
  name = "apo383-qa-nocost"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject"]
      Resource = "*"
    }]
  })

  tags = {
    Owner  = "qa-a1"
    Ticket = "APO-383"
  }
}
# webhook delivery probe
