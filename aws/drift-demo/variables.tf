variable "aws_region" {
  type        = string
  description = "AWS region to deploy the demo bucket into."
  default     = "us-east-1"
}

variable "owner" {
  type        = string
  description = "Value of the Owner tag. Change this env0 variable after a deployment to demonstrate the 'Variable Change' drift cause."
  default     = "platform-team"
}
