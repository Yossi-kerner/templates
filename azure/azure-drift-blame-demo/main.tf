# Providers and versions
provider "azurerm" {
  features {}
}

provider "random" {}

# Variables
variable "location" {
  default = "East US"
}

# Randomize resource names
resource "random_id" "storage_account_id" {
  byte_length = 8
}

resource "random_string" "unique_name" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-${random_string.unique_name.result}"
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "example" {
  name                     = "st${random_id.storage_account_id.hex}"
  resource_group_name       = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier               = "Standard"
  account_replication_type = "LRS"
}

# Enable static website hosting
resource "azurerm_storage_account_static_website" "example" {
  storage_account_id = azurerm_storage_account.example.id
  index_document     = "index.html"
}

# Upload HTML file (index.html)
resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = "web"
  type                   = "Block"
  source                 = <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome!</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      height: 100vh;
      background-color: #f4f4f9; /* Changed to a simple background color */
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .container {
      text-align: center;
      color: #333;
      padding: 20px;
      background: rgba(255, 255, 255, 0.8);
      border-radius: 10px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    h1 {
      font-size: 3.5em;
      font-weight: bold;
      margin: 0;
    }
    p {
      font-size: 1.5em;
      margin-top: 10px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Hello, dear guest!</h1>
    <p>Welcome to my playground website hosted on Azure!</p>
  </div>
</body>
</html>
HTML
}

# Output the website URL
output "website_url" {
  description = "The URL of the static website"
  value       = "https://${azurerm_storage_account.example.name}.z6.web.core.windows.net/"
}
