resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Password123!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    name                     = "example-vm-osdisk"
    caching                  = "ReadWrite"
    storage_account_type     = "Standard_LRS"
  }

  # Use the image ID directly
  source_image_id = "/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Compute/images/{image_name}"

  tags = {
    environment = "testing"
  }
}
