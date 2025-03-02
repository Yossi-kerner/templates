terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"  # Ensure you specify the correct provider version
    }
  }
}

module "storage_account" {
  source = "terraform-azurerm-modules/storage-account/azurerm"  # Correct source path for the module

  resource_group_name = "my_resource_group"  # Specify your resource group name
  location           = "East US"            # Specify the region for your storage account

  # Generate a random name for the storage account using random_id
  storage_account_name = "st${random_id.storage_account_prefix.hex}"

  account_tier           = "Standard"
  account_replication_type = "LRS"  # Locally redundant storage (can change to GRS, etc.)

  tags = {
    environment = "dev"
  }
}

resource "random_id" "storage_account_prefix" {
  byte_length = 8  # Generates a random prefix for the storage account name
}

output "storage_account_name" {
  value = module.storage_account.name
}
