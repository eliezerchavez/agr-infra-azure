resource "azurerm_storage_account" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.vnet.subnet.id]
  }

  account_kind                    = var.account.kind
  account_replication_type        = var.account.replication_type
  account_tier                    = var.account.tier
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}

resource "azurerm_storage_container" "this" {
  for_each = toset(var.containers)

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"

}

resource "azurerm_storage_share" "this" {
  for_each = var.shares

  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  quota              = each.value.quota

}


