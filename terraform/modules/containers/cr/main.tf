data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_container_registry" "this" {
  admin_enabled                 = var.admin_enabled
  location                      = var.rg.location
  name                          = var.name
  public_network_access_enabled = var.public_network_access_enabled
  resource_group_name           = var.rg.name
  sku                           = var.sku

  dynamic "georeplications" {
    for_each = var.georeplications

    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
    }
  }

  tags = var.tags

  lifecycle {
ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}

resource "azurerm_private_endpoint" "this" {
  name                = "${var.name}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  tags = var.tags

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  provider = azurerm.app

  lifecycle {
ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}
