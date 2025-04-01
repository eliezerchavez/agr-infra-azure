resource "azurerm_storage_account" "this" {
  name = var.name

  location            = var.rg.location
  resource_group_name = var.rg.name

  account_kind                    = var.account.kind
  account_replication_type        = var.account.replication_type
  account_tier                    = var.account.tier
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.vnet.subnet.id]
  }

  tags = var.tags

  provider = azurerm.app

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_storage_container" "this" {
  for_each = toset(var.containers)

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"

  provider = azurerm.app

}

resource "azurerm_storage_share" "this" {
  for_each = var.shares

  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  quota              = each.value.quota

  provider = azurerm.app

}

data "azurerm_private_dns_zone" "this" {
  for_each = toset(var.subresource_names)

  name                = "privatelink.${each.key}.core.windows.net"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_private_endpoint" "this" {
  for_each = toset(var.subresource_names)

  name                = "${var.name}-${each.key}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  tags = var.tags

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_storage_account.this.id
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
