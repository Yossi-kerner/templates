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
  project_id  = data.env0_project.default_project.id
  template_id = data.env0_template.example.id

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

resource "env0_variable_set" "organization_scope_example" {
  name        = "variable-set-example1"
  description = "description123"

  variable {
    name   = "n1"
    value  = "v1"
    format = "text"
  }

  variable {
    name         = "n1"
    value        = "v2"
    type         = "environment"
    format       = "text"
    is_sensitive = true
  }
}
