output "data_bucket_id" {
  description = "ID of the data storage S3 bucket"
  value       = aws_s3_bucket.data.id
}

output "data_bucket_arn" {
  description = "ARN of the data storage S3 bucket"
  value       = aws_s3_bucket.data.arn
}

output "data_bucket_domain_name" {
  description = "Domain name of the data storage S3 bucket"
  value       = aws_s3_bucket.data.bucket_domain_name
}

output "data_bucket_regional_domain_name" {
  description = "Regional domain name of the data storage S3 bucket"
  value       = aws_s3_bucket.data.bucket_regional_domain_name
}

output "logs_bucket_id" {
  description = "ID of the logging S3 bucket"
  value       = var.s3_logging_enabled ? aws_s3_bucket.logs[0].id : null
}

output "logs_bucket_arn" {
  description = "ARN of the logging S3 bucket"
  value       = var.s3_logging_enabled ? aws_s3_bucket.logs[0].arn : null
}
