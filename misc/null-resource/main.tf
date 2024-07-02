terraform {
  cloud {
    hostname = "backend.api.env0.com"
    organization = "4fbca492-2d85-4fb9-bef2-e87582cd690e.4e7bdcfa-8aa4-4118-86f0-dc424c49395a"

    workspaces {
      name = "null-69611-45812066"
    }
  }
}

variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

output "vpc_id" {
  value = "TEST1"
}

resource "null_resource" "null1" {
}
