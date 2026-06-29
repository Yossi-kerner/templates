remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = get_env("QA_STATE_BUCKET")
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = get_env("AWS_DEFAULT_REGION", "us-east-1")
    encrypt = true
  }
}

generate "main" {
  path      = "tg.main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "null_resource" "this" {}

output "id" {
  value = null_resource.this.id
}
EOF
}
