generate "main" {
  path      = "tg.main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "null_resource" "base" {}

output "base_id" {
  value = null_resource.base.id
}
EOF
}
