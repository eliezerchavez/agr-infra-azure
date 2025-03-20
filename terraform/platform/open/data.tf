#
# Shared Services/Resources
#

# Container Registry
data "azurerm_container_registry" "this" {
  name                = format("cr%s%s%03d", var.business_unit, (var.env == "prd" ? "prd" : "npd"), 1)
  resource_group_name = "rg-services-shared-001"
}

# Virtual Network
data "azurerm_resource_group" "net" {
  name = local.avangrid[var.business_unit].network[var.env == "prd" ? "prd" : "npd"].rg.name
}

data "azurerm_virtual_network" "net" {
  name                = local.avangrid[var.business_unit].network[var.env == "prd" ? "prd" : "npd"].int.name
  resource_group_name = local.avangrid[var.business_unit].network[var.env == "prd" ? "prd" : "npd"].rg.name
}
