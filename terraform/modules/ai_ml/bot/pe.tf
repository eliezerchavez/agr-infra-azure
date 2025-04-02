locals {
  private_dns_zone = {
    bot   = "privatelink.directline.botframework.com"
    token = "privatelink.token.botframework.com"
  }

}

data "azurerm_private_dns_zone" "this" {
  for_each = local.private_dns_zone

  name                = each.value
  resource_group_name = var.private_dns_rg

  provider = azurerm.hub
}

resource "azurerm_private_endpoint" "this" {
  for_each = local.private_dns_zone

  name                = "${var.name}-${each.key}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name

  subnet_id = var.vnet.subnet.id

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

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}
