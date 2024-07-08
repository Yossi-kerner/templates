terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
  }
}

provider "env0" {
  api_key    = "ai9hz4teack1oe4f"
  api_secret = "eSDP825BvlT8qYic5iNWrqaM2s8iql9t"
  api_endpoint = "https://api-dev.dev.env0.com"
}

data "env0_environment" "example_with_hcl_configuration" {
  name        = "environment with hcl"
}

# resource "env0_configuration_variable" "example" {
#   name        = "ENVIRONMENT_VARIABLE_NAME"
#   value       = "example value"
# }

resource "env0_variable_set" "organization_scope_example" {
  name        = "variable-set-example1"
  description = "description123"

  variable {
    name   = "ENVIRONMENT_VARIABLE_NAME"
    value  = "example value"
    format = "text"
  }
}
resource "env0_variable_set_assignment" "assignment" {
  scope    = "organization"
  scope_id = data.env0_environment.example_with_hcl_configuration.id
  set_ids = [
    env0_variable_set.organization_scope_example.id,
  ]
}
