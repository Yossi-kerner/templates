module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "my-unique-bucket-name"
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}
