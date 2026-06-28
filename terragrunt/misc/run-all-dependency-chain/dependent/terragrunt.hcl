dependency "base" {
  config_path = "../base"

  # Let the initial `run --all plan` resolve before `base` is applied.
  # Deliberately NOT allowed for apply/destroy: a wrong-order (forward) destroy tears
  # down `base` first, leaving no outputs, so resolving this dependency fails - which is
  # exactly the APO-117 bug. Reverse order destroys `dependent` first while `base` still
  # has outputs, so it succeeds.
  mock_outputs                            = { base_id = "mock-base-id" }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "workspace", "output"]
}

inputs = {
  base_id = dependency.base.outputs.base_id
}

generate "main" {
  path      = "tg.main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "base_id" {
  type    = string
  default = ""
}

resource "null_resource" "dependent" {}
EOF
}
