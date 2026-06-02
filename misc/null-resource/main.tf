terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
    # The "Big Three" cloud providers are massive
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    # Kubernetes and Helm providers also carry heavy dependencies
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# You must initialize them (even with dummy data) to force the download
provider "aws" { region = "us-east-1" }
provider "azurerm" { 
  features {} 
}
provider "google" { project = "qa-test" }

# Consumes the "test/test" module from the env0 private module registry,
# exercising the /modules/v1/.../download endpoint during terraform init.
module "registry_test" {
  source  = "api-dev.dev.env0.com/f0d9aced-99cf-4dfd-a17f-375d29bc3ca7/test/test"
  version = "2.0.0"
}

resource "null_resource" "heavy_dir" {
  provisioner "local-exec" {
    command = "echo 'Providers loaded for QA'"
  }
}

variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

output "vpc_id1" {
  value = "TEST2"
}

output "sensitive_vpc_id1" {
  value = "TEST2_SECRET"
  sensitive = true
}

resource "null_resource" "null1" {
}
