resource "azurerm_subnet" "this" {
  name                = var.name
  resource_group_name = var.rg.name

  virtual_network_name = var.vnet.name
  address_prefixes     = [var.address_prefix]

  service_endpoints = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegations
    content {
      name = delegation.key

      service_delegation {
        actions = delegation.value.service_delegation.actions
        name    = delegation.value.service_delegation.name
      }
    }
  }

}
