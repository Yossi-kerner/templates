terraform {
  required_version = ">= 1.0"
}

module "remote_state_bucket" {
  source = "github.com/env0/remote-state-bucket-module/aws"
  
  # Module-specific inputs
  bucket_name = "yossi-custom-bucket-for-remote-state"
  region      = "us-west-2"
  acl         = "private"
  enable_versioning = true
}

output "bucket_name" {
  value = module.remote_state_bucket.bucket_name
}
