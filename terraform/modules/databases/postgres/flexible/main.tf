data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "random_string" "this" {
  length  = 32
  override_special = "!$%*()-=[]{}<>:/|"

}

resource "azurerm_postgresql_flexible_server" "this" {
  administrator_login           = var.admin.username
  administrator_password        = var.admin.password == null ? random_string.this.result : var.admin.password
  location                      = var.rg.location
  name                          = var.name
  public_network_access_enabled = false
  resource_group_name           = var.rg.name
  sku_name                      = var.sku_name
  version                       = var.ver

  storage_mb            = var.storage_mb

  delegated_subnet_id = var.vnet.subnet.id
  private_dns_zone_id = data.azurerm_private_dns_zone.this.id

  tags = var.tags

  lifecycle {
    ignore_changes = [zone, tags]
  }

}
