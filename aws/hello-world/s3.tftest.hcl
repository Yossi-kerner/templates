run "test s3 bucket" {
  assert {
    condition     = aws_s3_bucket.website_bucket.bucket == "hello-env0-${random_string.random.result}"
    error_message = "Incorrect name of s3 bucket, the real name is ${aws_s3_bucket.website_bucket.bucket}."
  }
}