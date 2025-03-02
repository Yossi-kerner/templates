# local_module/main.tf

variable "instance_id" {
  description = "ID of the EC2 instance"
  type        = string
}

variable "public_ip" {
  description = "Public IP of the EC2 instance"
  type        = string
}

output "instance_details" {
  value = {
    id        = var.instance_id
    public_ip = var.public_ip
  }
}
