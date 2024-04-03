locals {
  api_endpoint    = "https://api-pr14873.dev.env0.com"
  env0_api_key    = "icii2m5qwd9vzdzn"
  env0_api_secret = "bA5-GJ86s1xj3k2zgQCUvwWxwBNV66Gq"
  project_name    = "yossi"
  organization_id = "f25510a1-2c6d-4ab7-91b8-2a26aee1be06"
}

terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
  }
}

provider "env0" {
  api_key         = local.env0_api_key
  api_secret      = local.env0_api_secret
  api_endpoint    = local.api_endpoint
  organization_id = local.organization_id
}

data "env0_organization" "my_organization" {}

output "organization_name" {
  value = data.env0_organization.my_organization.name
}

resource "env0_project" "default_project" {
  name        = local.project_name
  count       = 700
  description = "Very Long DEscription, Very Long DEscription, Very Long DEscription ,Very Long DEscription ,Very Long DEscription ,Very Long DEscriptionVery Long DEscription, Very Long DEscription, Very Long DEscription ,Very Long DEscription ,Very Long DEscription ,Very Long DEscriptionVery Long DEscription, Very Long DEscription, Very Long DEscription ,Very Long DEscription ,Very Long DEscription ,Very Long DEscriptionVery Long DEscription, Very Long DEscription, Very Long DEscription ,Very Long DEscription ,Very Long DEscription ,Very Long DEscriptionVery Long DEscription, Very Long DEscription, Very Long DEscription ,Very Long DEscription ,Very Long DEscription ,Very Long DEscription"
}

resource "env0_template" "null_template_1" {
  name        = "subenv1"
  description = "Sub Env 1"
  repository  = "https://github.com/tomer-landesman/templates"
  path        = "misc/null-resource"
  type        = "terraform"
}


# resource "env0_project" "default_sub_project" {
#   name              = local.project_name
#   count             = 300
#   parent_project_id = "233fb206-1cf6-4e85-bc83-4c29122b3be7"
# }
