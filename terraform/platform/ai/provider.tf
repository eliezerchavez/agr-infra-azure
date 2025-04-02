terraform {
  backend "azurerm" {
    resource_group_name  = "rg-util-shared-001"
    storage_account_name = "sautilqlaou"
    container_name       = "tfstate"
    # key                  = "app.tfstate"
  }

}

provider "azurerm" {
  subscription_id = local.avangrid[var.business_unit].subscriptions[var.env == "prd" ? "prd" : "npd"].id
  features {}

  resource_provider_registrations = "none"
  
}

provider "azurerm" {
  subscription_id = local.avangrid.shared.subscriptions.all.id
  features {}
  alias = "hub"

  resource_provider_registrations = "none"

}
