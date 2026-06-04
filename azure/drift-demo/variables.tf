variable "location" {
  type        = string
  description = "Azure region to deploy the demo resources into."
  default     = "East US"
}

variable "owner" {
  type        = string
  description = "Value of the Owner tag. Change this env0 variable after a deployment to demonstrate the 'Variable Change' drift cause."
  default     = "platform-team"
}
