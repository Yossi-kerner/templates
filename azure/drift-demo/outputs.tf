output "resource_group_name" {
  value       = azurerm_resource_group.drift_demo.name
  description = "Name of the demo resource group."
}

output "storage_account_name" {
  value       = azurerm_storage_account.drift_demo.name
  description = "Name of the demo storage account."
}
