terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0.0"  # Relax the version constraint as needed
    }
  }
}

provider "azurerm" {
  features {}  # This is required to configure the provider
}

resource "random_id" "storage_account_prefix" {
  byte_length = 8  # Generate a random prefix for the storage account name
}

resource "azurerm_storage_account" "example" {
  name                     = "st${random_id.storage_account_prefix.hex}"  # Storage account name must be between 3 and 24 characters
  resource_group_name       = "env0-xlwibvgp-group"
  location                 = "East US"
  account_tier              = "Standard"
  account_replication_type = "LRS"  # Locally redundant storage (LRS)

  tags = {
    environment = "dev"
  }
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
