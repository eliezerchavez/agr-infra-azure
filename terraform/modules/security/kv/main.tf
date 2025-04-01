data "azurerm_client_config" "current" {
  provider = azurerm.app

}

data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_key_vault" "this" {
  name                          = var.name
  location                      = var.rg.location
  resource_group_name           = var.rg.name
  enabled_for_disk_encryption   = true
  enable_rbac_authorization     = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  public_network_access_enabled = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "SetIssuers",
      "Update"
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Restore",
      "Restore",
      "Set"
    ]

    storage_permissions = [
      "Get"
    ]
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    virtual_network_subnet_ids = [var.vnet.subnet.id]
  }

  tags = var.tags

  provider = azurerm.app

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_private_endpoint" "this" {
  name                = "${var.name}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  tags = var.tags

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  depends_on = [azurerm_key_vault.this]

  provider = azurerm.app

  lifecycle {
    ignore_changes = [tags]
  }

}
