resource "azurerm_user_assigned_identity" "this" {
  count = length(var.identity_ids) > 0 ? 0 : 1

  name                = "${var.name}-id"
  location            = var.rg.location
  resource_group_name = var.rg.name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }
}

resource "azurerm_cognitive_account" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : [azurerm_user_assigned_identity.this[0].id]
  }

  custom_subdomain_name         = var.kind == "OpenAI" ? replace(regex("^.*?-(.*)", var.name)[0], "-", "") : replace(var.name, "-", "")
  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    # bypass         = var.network_acls.bypass
    default_action = var.network_acls.default_action
    ip_rules       = var.network_acls.ip_rules
  }

  kind     = var.kind
  sku_name = var.sku_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}
