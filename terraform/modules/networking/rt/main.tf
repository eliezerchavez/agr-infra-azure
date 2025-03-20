resource "azurerm_route_table" "this" {
  bgp_route_propagation_enabled = false
  location                      = var.rg.location
  name                          = var.name
  resource_group_name           = var.rg.name

  dynamic "route" {
    for_each = var.routes

    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }

  }

  tags = var.tags

  lifecycle {
    ignore_changes = [route, tags]
  }

}
