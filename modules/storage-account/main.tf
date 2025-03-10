# OpenTofu (Terraform) configuration to create a resource group and storage account with random names

provider "azurerm" {
  features {}
}

# Generate a random name for the resource group
resource "random_pet" "rg_name" {
  length = 8
}

# Create a new Resource Group with a random name
resource "azurerm_resource_group" "example" {
  name     = random_pet.rg_name.id
  location = "East US"
}

# Generate a random name for the storage account
resource "random_string" "storage_account_name" {
  length  = 12
  special = false
  upper   = false
  lower   = true
  number  = true
}

# Create a new Storage Account with the random name
resource "azurerm_storage_account" "example" {
  name                     = random_string.storage_account_name.result
  resource_group_name       = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier               = "Standard"
  account_replication_type = "LRS"
}

output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
