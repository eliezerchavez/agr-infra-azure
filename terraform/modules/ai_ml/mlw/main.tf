locals {
  identity = {
    ids = length(var.identity) > 0 ? var.identity.*.id : [azurerm_user_assigned_identity.this[0].id]
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

data "azurerm_user_assigned_identity" "this" {
  for_each = length(var.identity) > 0 ? toset(var.identity.*.id) : []

  name                = reverse(split("/", each.key))[0]
  resource_group_name = var.rg.name

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

resource "azurerm_role_assignment" "key_vault_reader" {
  for_each = toset(local.identity.ids)

  scope                = var.kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = data.azurerm_user_assigned_identity.this[each.key].principal_id
}

resource "azurerm_role_assignment" "storage_contributor" {
  for_each = toset(local.identity.ids)

  scope                = var.storage.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.this[each.key].principal_id
}

resource "azurerm_role_assignment" "application_insights_contributor" {
  for_each = toset(local.identity.ids)

  scope                = var.appi.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.this[each.key].principal_id
}

resource "azurerm_role_assignment" "cr" {
  for_each = try(var.cr.id, null) != null ? toset(local.identity.ids) : []

  scope                = var.cr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_user_assigned_identity.this[each.key].principal_id

}

resource "time_sleep" "wait_for_iam" {
  depends_on      = [azurerm_role_assignment.key_vault_reader]
  create_duration = "60s"
}

resource "azurerm_machine_learning_workspace" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  kind     = var.kind
  sku_name = var.sku_name

  application_insights_id = var.appi.id
  container_registry_id   = try(var.cr.id, null)
  key_vault_id            = var.kv.id
  storage_account_id      = var.storage.id

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity) > 0 ? var.identity.*.id : [azurerm_user_assigned_identity.this[0].id]
  }

  primary_user_assigned_identity = length(var.identity) > 0 ? var.identity[0].id : azurerm_user_assigned_identity.this[0].id

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.key_vault_reader,
    azurerm_role_assignment.storage_contributor,
    azurerm_role_assignment.application_insights_contributor,
    azurerm_role_assignment.cr
  ]

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
    subresource_names              = ["amlworkspace"]
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
