provider "aws" {
  region = "us-east-1" # You can change the region as needed
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-123456-yossi-kerner-hello"
  acl    = "private"

  tags = {
    Name                 = "MyBucket"
    Environment         = "Dev"
    Test                = "Test"
    env0_environment_id = "2cb3d888-a555-4051-a174-2927f3a3b7fd"
    env0_project_id     = "94235f30-fa44-4d97-8193-494cf851e2cc"
  }
}
