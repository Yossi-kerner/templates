resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "drift_demo" {
  name     = "env0-drift-demo-${random_string.suffix.result}"
  location = var.location

  tags = {
    ManagedBy = "env0"
    Owner     = var.owner
    Purpose   = "drift-detection-demo"
  }
}

resource "azurerm_storage_account" "drift_demo" {
  name                     = "env0drift${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.drift_demo.name
  location                 = azurerm_resource_group.drift_demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  allow_nested_items_to_be_public = false

  tags = {
    ManagedBy = "env0"
    Owner     = var.owner
    Purpose   = "drift-detection-demo"
  }
}
