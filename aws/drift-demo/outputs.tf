output "bucket_name" {
  value       = aws_s3_bucket.drift_demo.id
  description = "Name of the demo S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.drift_demo.arn
  description = "ARN of the demo S3 bucket."
}
