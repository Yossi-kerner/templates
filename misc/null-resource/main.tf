variable "test" {
  description = "test"
  type        = string
  default     = "default"
}

output "vpc_id1" {
  value = "TEST1"
}

resource "null_resource" "null1" {
}

resource "null_resource" "null2" {
}

resource "null_resource" "null3" {
}
