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

resource "env0_environment" "new_env" {
  name        = "new env"
  project_id  = "72002433-9307-40b5-bf28-67b37b12e296"
  template_id = "1ce774a2-71ac-4047-8cb2-da09973af08a"

  configuration {
    name          = "TEST1234"
    type          = "terraform"
    value         = <<EOF
      {
        a = "world11111"
        b = {
          c = "d"
        }
      }
    EOF
    schema_format = "HCL"
  }
}

# resource "env0_variable_set" "organization_scope_example" {
#   name        = "variable-set-example1"
#   description = "description123"# 
#
#   variable {
#     name          = "TEST1234"
#     type          = "terraform"
#     value         = <<EOF
#       {
#         a = "world11111"
#        b = {
#          c = "d"
#        }
#      }
#    EOF
#     format = "HCL"
#   }
# }
#
# resource "env0_variable_set_assignment" "assignment" {
#   scope    = "environment"
#   scope_id = env0_environment.new_env.id
#   set_ids = [
#     env0_variable_set.organization_scope_example.id,
#   ]
# }
