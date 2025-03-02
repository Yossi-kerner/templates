terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "storage_account" {
  source  = "Azure/azurerm/storage-account"
  version = "~> 4.0"  # Ensure you're using the appropriate version of the module

  resource_group_name = "my_resource_group" # Set your resource group name
  location           = "East US"            # Set your desired Azure region

  # Generate a random name for the storage account
  storage_account_name = "st${random_id.storage_account_prefix.hex}"

  account_tier           = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "random_id" "storage_account_prefix" {
  byte_length = 8
}

output "storage_account_name" {
  value = module.storage_account.name
}
