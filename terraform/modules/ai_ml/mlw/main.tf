data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_user_assigned_identity" "this" {
  count = length(var.identity) == 0 ? 1 : 0

  name                = "id-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  lifecycle {
    ignore_changes = [tags]
  }

}

module "st" {
  count = var.storage.id != "" ? 1 : 0

  source = "../storage/st"

  name = format("sa%s", var.name)

  pe = local.pe

  rg = local.rg

  subresource_names = ["blob", "file"]

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-GENERAL"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}

resource "azurerm_machine_learning_workspace" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  public_network_access_enabled = var.public_network_access_enabled
  sku_name                      = var.sku_name

  application_insights_id = var.appi.id
  container_registry_id   = var.cr.id
  key_vault_id            = var.kv.id
  storage_account_id      = var.storage.id != "" ? module.st.id : var.storage.id

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity) > 0 ? var.identity.*.id : [azurerm_user_assigned_identity.this[0].id]
  }

  tags = var.tags

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
    private_connection_resource_id = azurerm_machine_learning_workspace.this.id
    subresource_names              = ["account"]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  lifecycle {
    ignore_changes = [tags]
  }

}
