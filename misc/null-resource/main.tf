variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

resource "null_resource" "null" {
}

resource "null_resource" "null2" {
}

output "vpc_id" {
  value = var.test
}
