resource "azurerm_user_assigned_identity" "this" {
  count = length(var.identity_ids) > 0 ? 0 : 1

  name                = "id-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }

}

resource "azurerm_search_service" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : [azurerm_user_assigned_identity.this[0].id]
  }

  allowed_ips                   = var.allowed_ips
  network_rule_bypass_option    = var.network_rule_bypass_option
  public_network_access_enabled = var.public_network_access_enabled
  
  hosting_mode                  = var.hosting_mode
  partition_count = var.partition_count
  replica_count   = var.replica_count == 0 ? null : var.replica_count
  sku             = var.sku

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }

}
