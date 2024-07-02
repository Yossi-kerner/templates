data "terraform_remote_state" "example" {
  backend = "remote"

  config = {
    hostname     = "backend.api.env0.com"
    organization = "52e69ba9-1596-4565-89f5-9df45cc59ccb"
    workspaces = {
      name = "env0f30c18"
    }
  }
}

output "yossi" {
  value = data.terraform_remote_state.example.outputs.vpc_id
}
