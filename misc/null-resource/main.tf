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
  value = "TEST2"
}

output "sensitive_vpc_id1" {
  value = "TEST2_SECRET"
  sensitive = true
}

resource "null_resource" "null1" {
}
