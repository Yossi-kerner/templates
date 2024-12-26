provider "azurerm" {
  features {}
}

import "azurerm_storage_account" "example_storage_account" {
  id = "/subscriptions/b48787a1-7145-425f-99af-62cde6c50e31/resourcegroups/env0-b09jjokn-group/providers/Microsoft.Storage/storageAccounts/stb09jjokn"
}

# Free-tier Azure Storage Account
resource "azurerm_storage_account" "storage" {
  account_tier              = "Standard"
  account_replication_type = "LRS"
  
  # The name must be globally unique, so we'll append a random string.
  account_kind = "StorageV2"  # General-purpose v2 storage account is recommended.
  
  tags = {
    environment = "dev"
  }
}
