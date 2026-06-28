dependency "base" {
  config_path = "../base"

  # env0 manages remote state, so Terragrunt can't read a dependency's real outputs during
  # its config-resolution phase; mock_outputs is required for the run to resolve at all.
  # Allowed for every command (no mock_outputs_allowed_terraform_commands restriction) so
  # both deploy and destroy resolve. The dependency edge still forces ordering: forward on
  # deploy (base -> dependent), reverse on destroy (dependent -> base) - which is what the
  # APO-117 fix produces.
  mock_outputs = { base_id = "mock-base-id" }
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
