provider "azurerm" {
  features {}
}

import "azurerm_storage_account" "example_storage_account" {
  id = "/subscriptions/b48787a1-7145-425f-99af-62cde6c50e31/resourcegroups/env0-b09jjokn-group/providers/Microsoft.Storage/storageAccounts/stb09jjokn"
}
