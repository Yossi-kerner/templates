provider "azurerm" {
  features {}
  version = "4.22.0"
  subscription_id = "b48787a1-7145-425f-99af-62cde6c50e31"
}

resource "null_resource" "null" { }

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "group" {
  name     = "env0-${random_string.random.result}-group"
  location = "northeurope"
}

# Free-tier Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "st${random_string.random.result}"
  resource_group_name       = azurerm_resource_group.group.name
  location                 = azurerm_resource_group.group.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
  
  # The name must be globally unique, so we'll append a random string.
  account_kind = "StorageV2"  # General-purpose v2 storage account is recommended.
  
  tags = {
    environment = "dev"
  }
}
