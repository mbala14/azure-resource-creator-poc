# Configure the Azure provider from hashicorp
#Terraform will download this provider from the Terraform Registry.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.39.0"
    }
  }
}

# provider "azurerm" {
#   features {}
# }

provider "azurerm" {
  features {
 # This is the correct location
  }
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "rg" {
  name     = "myapp-poc-resource-group"
  location = "East US"
}

resource "azurerm_storage_account" "storage" {
  name                     = "infazurestorageacct786"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

   tags = {
      environment = "dev"
    }
}

