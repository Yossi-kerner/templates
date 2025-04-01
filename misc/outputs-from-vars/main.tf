# Declare the variables
variable "tf_variable_1" {
  description = "First TensorFlow-like variable"
  type        = string
  default     = "value_1"
}

variable "tf_variable_2" {
  description = "Second TensorFlow-like variable"
  type        = string
  default     = "value_2"
}

variable "tf_variable_3" {
  description = "Third TensorFlow-like variable"
  type        = string
  default     = "value_3"
}

variable "tf_variable_4" {
  description = "Third TensorFlow-like variable"
  type        = string
  default     = "value_4"
}

# Define the outputs based on variables
output "output_1" {
  value = var.tf_variable_1
}

output "output_2" {
  value = var.tf_variable_2
}

output "output_3" {
  value = var.tf_variable_3
}

output "output_4" {
  value = var.tf_variable_4
}

resource "null_resource" "test" {

}
