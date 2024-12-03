resource "aws_s3_bucket" "logs_bucket" {
  bucket = "demo-logs-storage"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.logs_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket = aws_s3_bucket.logs_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership,
    aws_s3_bucket_public_access_block.bucket_public_access_block
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Allow-Public-Access-To-Bucket"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.logs_bucket.bucket}/*"
        ]
      },
    ]
  })
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.logs_bucket.bucket
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}
