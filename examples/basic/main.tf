terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example-function-app"
  location = "francecentral"
}

resource "azurerm_service_plan" "example" {
  name                = "plan-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

module "function_app" {
  source  = "app.terraform.io/alderic-hoarau/function-app/azurerm"
  version = "~> 0.1"

  name                 = "fn-example"
  storage_account_name = "stfnexample"
  resource_group_name  = azurerm_resource_group.example.name
  location             = azurerm_resource_group.example.location
  service_plan_id      = azurerm_service_plan.example.id

  tags = {
    owner = "example"
  }
}

output "default_hostname" {
  value = module.function_app.default_hostname
}
