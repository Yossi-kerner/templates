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

variable "instance_type" {
  type    = string
  default = "t3.micro"
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

resource "aws_instance" "qa" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name   = "apo383-qa-priced-${var.suffix}"
    Owner  = var.owner
    Ticket = "APO-383"
  }
}
