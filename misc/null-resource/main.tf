variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

resource "null_resource" "null1" {
}

output "vpc_id" {
  value = var.test
}
