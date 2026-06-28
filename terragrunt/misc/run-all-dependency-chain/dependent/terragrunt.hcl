dependency "base" {
  config_path = "../base"

  # mock_outputs let the initial deploy resolve `dependency.base.outputs` before `base`
  # exists. The list excludes apply/destroy on purpose: a wrong-order (forward) destroy
  # tears `base` down first, so resolving this dependency then fails with
  # "detected no outputs" - exactly the APO-117 bug. Reverse order destroys `dependent`
  # first while `base` still has outputs, so it succeeds.
  mock_outputs                            = { base_id = "mock-base-id" }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "workspace", "output"]
}

# Consume the dependency output so Terragrunt must read `base`'s state on every run
# (this is what makes destroy ordering matter). It is intentionally NOT declared as a
# Terraform variable below, so OpenTofu ignores the value instead of consistency-checking
# it against env0's saved run-all plan (which would otherwise fail on the mock->real change).
inputs = {
  base_id = dependency.base.outputs.base_id
}

generate "main" {
  path      = "tg.main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "null_resource" "dependent" {}
EOF
}
