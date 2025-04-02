resource "azurerm_redis_cache" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = var.public_network_access_enabled

  capacity = var.sku.capacity
  family   = var.sku.family
  sku_name = var.sku.name

  patch_schedule {
    day_of_week    = "Sunday"
    start_hour_utc = 0
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }
}
