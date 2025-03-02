# main.tf

module "remote_module" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.0.0"  # Specify the version you want
}

module "local_module" {
  source      = "./local_module"
  instance_id = module.remote_module.instance_id
  public_ip   = module.remote_module.public_ip
}

output "instance_details" {
  value = module.local_module.instance_details
}
