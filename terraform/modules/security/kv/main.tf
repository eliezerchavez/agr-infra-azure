data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  enable_rbac_authorization   = var.enable_rbac_authorization
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Restore", "Restore", "Set"]
    storage_permissions     = ["Get"]
  }

  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    virtual_network_subnet_ids = [var.vnet.subnet.id]
  }

  sku_name = var.sku_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }
}
