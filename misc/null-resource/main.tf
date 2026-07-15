terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

resource "null_resource" "heavy_dir" {
  provisioner "local-exec" {
    command = "echo 'Providers loaded for QA - ENG-2078'"
  }
}

variable "test" {
  description = "test"
  type        = string
  default     = "eng2078-qa"
}
