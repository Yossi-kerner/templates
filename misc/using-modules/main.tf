# Configure AWS provider
provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "my-unique-bucket-name"
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}
