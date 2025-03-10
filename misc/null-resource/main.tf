terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

output "vpc_id1" {
  value = "new TEST1"
}

resource "null_resource" "null1" {
}

resource "null_resource" "null2" {
}
