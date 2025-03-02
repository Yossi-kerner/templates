# main.tf

module "remote_module" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.0.0"  # Specify the version of the module
  name    = "example-instance"
  count   = 1  # Create 1 instance
  ami     = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
}

module "local_module" {
  source      = "./local_module"
  instance_id = module.remote_module[0].instance_ids[0]  # Accessing the first instance ID in the list
  public_ip   = module.remote_module[0].public_ips[0]    # Accessing the first public IP in the list
}

output "instance_details" {
  value = module.local_module.instance_details
}
