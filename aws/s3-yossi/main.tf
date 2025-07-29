provider "aws" {
  region = "us-east-1" # You can change the region as needed
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-123456-yossi-kerner-hello"
  acl    = "private"

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}
