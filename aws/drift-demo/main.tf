resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "drift_demo" {
  bucket = "env0-drift-demo-${random_id.suffix.hex}"

  tags = {
    Name      = "env0-drift-demo"
    ManagedBy = "env0"
    Owner     = var.owner
    Purpose   = "drift-detection-demo"
    Team      = "security"
  }
}

resource "aws_s3_bucket_public_access_block" "drift_demo" {
  bucket = aws_s3_bucket.drift_demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
