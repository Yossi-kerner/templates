terraform {
  cloud {
    hostname = "backend-pr16240.api.env0.com"
    organization = "52e69ba9-1596-4565-89f5-9df45cc59ccb.0e757317-5a22-4ba5-97a8-1d45a17b56ca"

    workspaces {
      name = "env0f78252"
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
