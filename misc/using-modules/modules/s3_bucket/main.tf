resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}-${random_id.suffix.hex}-yossi"
  acl     = "private"  # Static ACL
}
