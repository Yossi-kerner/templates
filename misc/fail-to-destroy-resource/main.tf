variable "name" {}

output "greeting" {
  value = "Hello ${var.name}!"
}

resource null_resource test {
  lifecycle {
    prevent_destroy = true
  }
}
