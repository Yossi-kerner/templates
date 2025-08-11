terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to your bucket's region
}

resource "aws_s3_bucket" "yossi_test_new" {
  bucket = "yossi-test-new"
}

import {
  id = "yossi-test-new"
  to = aws_s3_bucket.yossi_test_new
}
