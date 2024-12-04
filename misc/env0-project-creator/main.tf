# Terraform 0.13+ uses the Terraform Registry:

terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
  }
}

variable "api_key" {
  type = string
}

variable "api_secret" {
  type = string
}

variable "organization_id" {
  type = string
}

# Configure the env0 provider

provider "env0" {
  api_endpoint = "https://api-dev.dev.env0.com"
  api_key = var.api_key
  api_secret = var.api_secret
  organization_id = var.organization_id
}

resource "env0_project" "example1" {
  name        = "example 1"
  description = "Example project"
}
