# main.tf

module "remote_module" {
  source  = "./remote_module"
}

module "local_module" {
  source      = "./local_module"
  vm_id       = module.remote_module.vm_id  # Pass the VM ID from remote module output
  public_ip   = module.remote_module.public_ip  # Pass the public IP from remote module output
}

output "instance_details" {
  value = module.local_module.instance_details
}
