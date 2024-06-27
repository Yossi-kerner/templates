variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

output "vpc_id" {
  value = "TEST1"
}

output "another_outputs" {
  value = "TEST2"
}

resource "null_resource" "null1" {
}
