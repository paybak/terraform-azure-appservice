terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.46.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "app-resource-group" {
    name        = "paybak-resource-group"
    location    = "westus2"
}

resource "azurerm_app_service_plan" "service-plan" {
    name                = "paybak-service-plan"
    location            = azurerm_resource_group.app-resource-group.location
    resource_group_name = azurerm_resource_group.app-resource-group.name
    kind                = "Linux"
    reserved            = true

    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "app-service" {
    name                = "paybak-app-service"
    location            = azurerm_resource_group.app-resource-group.location
    resource_group_name = azurerm_resource_group.app-resource-group.name
    app_service_plan_id = azurerm_app_service_plan.service-plan.id

    site_config {
        linux_fx_version = "NODE|12.9"
    }
}