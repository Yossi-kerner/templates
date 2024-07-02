data "terraform_remote_state" "example" {
  backend = "remote"

  config = {
    hostname     = "backend-pr16240.api.dev.env0.com"
    organization = "37c52ad3-d171-411e-993e-1cc444806f56"
    workspaces = {
      name = "null-57180-37646142"
    }
  }
}

output "yossi" {
  value = data.terraform_remote_state.example.outputs.vpc_id
}
