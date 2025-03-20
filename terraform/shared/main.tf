resource "azurerm_resource_group" "this" {
  name     = format("rg-services-shared-%03d", 1)
  location = var.location

  tags = local.tags

}

module "acr" {
  source = "../modules/containers/acr"

  name = format("cr%s%s%03d", var.business_unit, var.env, 1)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-IT_TOOLS"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}
