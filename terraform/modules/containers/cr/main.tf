resource "azurerm_container_registry" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  admin_enabled = var.admin_enabled

  public_network_access_enabled = var.public_network_access_enabled

  sku = var.sku

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
