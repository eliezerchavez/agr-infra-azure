data "azurerm_client_config" "current" {
  provider = azurerm.app

}

data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.botframework.com"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_bot_channels_registration" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name
  sku                 = var.sku
  microsoft_app_id    = data.azurerm_client_config.current.client_id

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  tags = var.tags

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_bot_channels_registration.this.id
    subresource_names              = ["bot"]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  lifecycle {
    ignore_changes = [tags]
  }

}
