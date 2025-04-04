provider "azurerm"{
    subscription_id = var.subscription_id
    features {}
}

# Referenciar el grupo de recursos existente
data "azurerm_resource_group" "rg" {
  name = "rg-ecommerce-dev"
}

data "azurerm_storage_account" "saccount" {
  name                 = "sa${var.project}${var.environment}"
  resource_group_name  = data.azurerm_resource_group.rg.name
}