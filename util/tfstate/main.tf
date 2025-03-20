/* 
 * Author:     Eliezer Chavez <eliezer.chavez@avangrid.com>
 * Created:    2025-03-16
 * Purpose:    Store Terraform state in Azure Storage
 * Add'l Info: https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform

 * (c) Copyright by Avangrid, Inc.
 */

locals {
  tags = {
    APP_ID          = "AP40702"
    APP_NAME        = "AP_PLT_AZURE_CLOUD"
    "BUSINESS UNIT" = "CORPORATION USA"
    ENTERPRISE      = "AVANGRID"
    WORKGROUP       = "USA-INFO TECHNOLOGY"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.23.0"

    }
  }
}

provider "azurerm" {
  subscription_id = "6b48db3f-9a9a-4ea2-9eb7-356d9852accd" # IB-USA-CORPO-M-COMMONSERVICES
  features {}

  resource_provider_registrations = "none"

}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false

}

resource "azurerm_resource_group" "this" {
  name     = "rg-util-shared-001"
  location = "eastus"

  tags = local.tags

}

resource "azurerm_storage_account" "this" {
  name                            = "sautil${random_string.this.result}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  allow_nested_items_to_be_public = false

  tags = local.tags

}

resource "azurerm_storage_container" "this" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"

}
