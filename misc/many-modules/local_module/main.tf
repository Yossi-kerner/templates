# local_module/main.tf

variable "vm_id" {
  description = "ID of the Azure VM"
  type        = string
}

variable "public_ip" {
  description = "Public IP of the Azure VM"
  type        = string
}

output "instance_details" {
  value = {
    vm_id      = var.vm_id
    public_ip  = var.public_ip
  }
}
