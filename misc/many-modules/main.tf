# Configure the OpenTofu provider (AWS as an example)
provider "aws" {
  region = "us-west-2"
}

# --------- 1. Using a Remote Git Module ---------
module "vpc_git" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v3.14.0"  # Remote Git repository with a tag
  cidr    = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# --------- 2. Using a Terraform Registry Module ---------
# This example uses a module from the official Terraform Registry.

module "vpc_registry" {
  source  = "terraform-aws-modules/vpc/aws"  # Terraform Registry module
  version = "v3.14.0"  # Specific version from the Registry
  cidr    = "10.2.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# --------- 3. Using a Module from an HTTP URL ---------
# Using the terraform-aws-vpc module from GitHub as a .zip file

module "vpc_http" {
  source  = "https://github.com/terraform-aws-modules/terraform-aws-vpc/archive/refs/tags/v3.14.0.zip"  # Module as a ZIP from GitHub
  cidr    = "10.3.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Example resources that use the outputs from the VPC modules

resource "aws_subnet" "subnet_git" {
  vpc_id     = module.vpc_git.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet_registry" {
  vpc_id     = module.vpc_registry.vpc_id
  cidr_block = "10.2.1.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "subnet_http" {
  vpc_id     = module.vpc_http.vpc_id
  cidr_block = "10.3.1.0/24"
  availability_zone = "us-west-2c"
}

output "vpc_id_git" {
  value = module.vpc_git.vpc_id
}

output "vpc_id_registry" {
  value = module.vpc_registry.vpc_id
}

output "vpc_id_http" {
  value = module.vpc_http.vpc_id
}
