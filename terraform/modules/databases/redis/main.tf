data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_redis_cache" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  capacity = var.sku.capacity
  family   = var.sku.family
  sku_name = var.sku.name

  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  patch_schedule {
    day_of_week    = "Sunday"
    start_hour_utc = 0
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }

}

resource "azurerm_private_endpoint" "this" {
  name                = "${var.name}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_redis_cache.this.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  depends_on = [azurerm_redis_cache.this]

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }

}
