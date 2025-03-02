# main.tf

module "remote_module" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.0.0"  # Ensure the correct version is used
  name    = "example-instance"
  instance_count = 1
  ami     = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
}

module "local_module" {
  source      = "./local_module"
  instance_id = module.remote_module.instance_ids[0]  # Accessing the first instance ID in the list
  public_ip   = module.remote_module.public_ips[0]    # Accessing the first public IP in the list
}

output "instance_details" {
  value = module.local_module.instance_details
}
