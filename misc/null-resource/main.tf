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
