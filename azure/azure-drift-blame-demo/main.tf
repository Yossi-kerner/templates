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
      background: url('https://www.example.com/cat.jpg') no-repeat center center fixed;
      background-size: cover;
    }
    .overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.4);
    }
    .container {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
      color: white;
      padding: 20px;
      border-radius: 10px;
      background: rgba(0, 0, 0, 0.6);
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
  <div class="overlay"></div>
  <div class="container">
    <h1>Hello, dear guest!</h1>
    <p>Welcome to my playground website hosted on Azure!</p>
  </div>
</body>
</html>
HTML
}

# Upload Cat image (optional, if you want to store the image directly in Azure)
resource "azurerm_storage_blob" "cat_image" {
  name                   = "cat.jpg"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = "web"
  type                   = "Block"
  source                 = "path_to_your_local_cat_image.jpg" # Path to your local cat image (optional)
}

# Output the website URL
output "website_url" {
  value = azurerm_storage_account_static_website.example.primary_web_endpoint
}
