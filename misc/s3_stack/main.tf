/*
  S3 Stack
  
  This module creates an enterprise-grade S3 setup with the following features:
  - Main data bucket with versioning and encryption
  - Lifecycle policies for cost optimization
  - Access logging for security compliance
  - CORS configuration for web applications
  - Bucket policies for secure access
  - Inventory configuration for large-scale data management
*/

# Random suffix to ensure globally unique bucket names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Main data storage bucket
resource "aws_s3_bucket" "data" {
  bucket = "${var.project_name}-${var.environment}-data-${random_string.bucket_suffix.result}"
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-data"
    Environment = var.environment
    Purpose     = "Application data storage"
  }
}

# Bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for data integrity and recovery
resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  
  versioning_configuration {
    status = var.s3_versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle policy for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  
  # Archive older versions to cheaper storage
  rule {
    id     = "archive-old-versions"
    status = "Enabled"
    
    filter {
      prefix = "data/"
    }
    
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
    
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }
    
    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
  
  # Clean up incomplete multipart uploads
  rule {
    id     = "delete-incomplete-uploads"
    status = "Enabled"
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
  
  # Archive logs to cheaper storage
  rule {
    id     = "archive-logs"
    status = "Enabled"
    
    filter {
      prefix = "logs/"
    }
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    
    expiration {
      days = 365
    }
  }
}

# Logging bucket for access logs
resource "aws_s3_bucket" "logs" {
  count = var.s3_logging_enabled ? 1 : 0
  
  bucket = "${var.project_name}-${var.environment}-logs-${random_string.bucket_suffix.result}"
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-logs"
    Environment = var.environment
    Purpose     = "Access logging"
  }
}

# Block public access to logs bucket
resource "aws_s3_bucket_public_access_block" "logs" {
  count = var.s3_logging_enabled ? 1 : 0
  
  bucket = aws_s3_bucket.logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Ownership controls for logs bucket
resource "aws_s3_bucket_ownership_controls" "logs" {
  count = var.s3_logging_enabled ? 1 : 0
  
  bucket = aws_s3_bucket.logs[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure access logging
resource "aws_s3_bucket_logging" "data" {
  count = var.s3_logging_enabled ? 1 : 0
  
  bucket = aws_s3_bucket.data.id
  
  target_bucket = aws_s3_bucket.logs[0].id
  target_prefix = "s3-access-logs/"
}

# CORS configuration for web applications
resource "aws_s3_bucket_cors_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = var.environment == "prod" ? ["https://*.${var.project_name}.com"] : ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Bucket policy for secure access
resource "aws_s3_bucket_policy" "data" {
  bucket = aws_s3_bucket.data.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSL"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.data.arn,
          "${aws_s3_bucket.data.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# S3 inventory configuration for large-scale data management
resource "aws_s3_bucket_inventory" "data" {
  bucket = aws_s3_bucket.data.id
  name   = "EntireBucketDaily"
  
  included_object_versions = "Current"
  
  schedule {
    frequency = "Daily"
  }
  
  destination {
    bucket {
      format     = "CSV"
      bucket_arn = var.s3_logging_enabled ? aws_s3_bucket.logs[0].arn : aws_s3_bucket.data.arn
      prefix     = var.s3_logging_enabled ? "inventory" : "inventory/self"
    }
  }
  
  optional_fields = [
    "Size",
    "LastModifiedDate",
    "StorageClass",
    "ETag",
    "IsMultipartUploaded",
    "ReplicationStatus",
    "EncryptionStatus"
  ]
}
