data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.private_dns_rg

  provider = azurerm.hub
}

resource "random_string" "this" {
  length           = 32
  override_special = "!$%*()-=[]{}<>:/|"
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  administrator_login    = var.admin.username
  administrator_password = var.admin.password == null ? random_string.this.result : var.admin.password

  public_network_access_enabled = var.public_network_access_enabled
  delegated_subnet_id           = var.vnet.subnet.id
  private_dns_zone_id           = data.azurerm_private_dns_zone.this.id

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  version    = var.ver

  tags = var.tags

  lifecycle {
    ignore_changes = [zone, tags["CreatedAt"], tags["CREATOR"]]
  }

}
