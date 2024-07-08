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

resource "env0_environment" "example_with_hcl_configuration" {
  name        = "environment with hcl"
  project_id  = "72002433-9307-40b5-bf28-67b37b12e296"
  template_id = "1ce774a2-71ac-4047-8cb2-da09973af08a"
}

resource "env0_configuration_variable" "example" {
  name        = "ENVIRONMENT_VARIABLE_NAME"
  value       = "example value"
  description = "Here you can fill description for this variable, note this field have limit of 255 chars"
}

# resource "env0_variable_set" "organization_scope_example" {
#   name        = "variable-set-example1"
#   description = "description123"
# 
#   variable {
#     name   = "n1"
#     value  = "v1"
#     format = "text"
#   }
# 
#   variable {
#     name         = "n1"
#     value        = "v2"
#     type         = "environment"
#     format       = "text"
#     is_sensitive = true
#   }
# }

# resource "env0_variable_set_assignment" "assignment" {
#   scope    = "organization"
#   scope_id = data.example_with_hcl_configuration.id
#   set_ids = [
#     env0_variable_set.organization_scope_example.id,
#   ]
# }
