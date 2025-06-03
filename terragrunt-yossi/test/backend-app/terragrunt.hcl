terraform {
  source = "."
}

inputs = {
  instance_type = "t3.micro"
}

generate "precondition_block" {
  path      = "generated_precondition.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable "instance_type" {
  type = string
}

resource "null_resource" "example" {
  triggers = {
    instance_type = var.instance_type
  }

  lifecycle {
    precondition {
      condition     = var.instance_type == "t3.micro"
      error_message = "Only t3.micro instance type is allowed."
    }
  }
}
EOF
}
