data "azurerm_virtual_network" "this" {
  name                = local.avangrid[var.business_unit].network[var.env == "prd" ? "prd" : "npd"].int.name
  resource_group_name = local.avangrid[var.business_unit].network[var.env == "prd" ? "prd" : "npd"].rg.name
}
