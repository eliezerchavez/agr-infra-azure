locals {
  subresource_names = ["bot", "token"]
}

resource "azurerm_bot_channels_registration" "this" {
  name                = var.name
  location            = "global" # var.rg.location
  resource_group_name = var.rg.name
  sku                 = var.sku
  microsoft_app_id    = var.identity

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

data "azurerm_private_dns_zone" "this" {
  for_each = toset(local.subresource_names)

  name                = each.key == "bot" ? "privatelink.directline.botframework.com" : "privatelink.${each.key}.botframework.com"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_private_endpoint" "this" {
  for_each = toset(local.subresource_names)

  name                = "${var.name}-${each.key}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  tags = var.tags

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_bot_channels_registration.this.id
    subresource_names              = [each.key]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this[each.key].id]
  }

  provider = azurerm.app

  lifecycle {
    ignore_changes = [tags]
  }

}
