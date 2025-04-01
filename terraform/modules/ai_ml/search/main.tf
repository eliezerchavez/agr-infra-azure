data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.search.windows.net"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub

}

resource "azurerm_user_assigned_identity" "this" {
  count = length(var.identity) == 0 ? 1 : 0

  name                = "id-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_search_service" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  sku             = var.sku
  partition_count = var.partition_count
  replica_count   = var.replica_count

  hosting_mode = var.hosting_mode

  allowed_ips                = var.allowed_ips
  network_rule_bypass_option = var.network_rule_bypass_option

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity) > 0 ? var.identity.*.id : [azurerm_user_assigned_identity.this[0].id]
  }

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
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
    private_connection_resource_id = azurerm_search_service.this.id
    subresource_names              = ["searchService"]
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
