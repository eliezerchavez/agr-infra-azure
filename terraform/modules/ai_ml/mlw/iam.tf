locals {
  identity = {
    ids = (
      length(var.identity_ids) > 0
      ? { for k, v in data.azurerm_user_assigned_identity.this : k => { principal_id = v.principal_id } }
      : { for k, v in azurerm_user_assigned_identity.this : k => { principal_id = v.principal_id } }
    )
  }
}

data "azurerm_user_assigned_identity" "this" {
  for_each = length(var.identity_ids) > 0 ? toset(var.identity_ids) : []

  name                = reverse(split("/", each.key))[0]
  resource_group_name = var.rg.name

}

resource "azurerm_user_assigned_identity" "this" {
  count = length(var.identity_ids) > 0 ? 0 : 1

  name                = "id-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  lifecycle {
ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}

resource "azurerm_role_assignment" "key_vault_reader" {
  for_each = local.identity.ids

  scope                = var.kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  for_each = local.identity.ids

  scope                = var.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "application_insights_component_contributor" {
  for_each = local.identity.ids

  scope                = var.appi.id
  role_definition_name = "Application Insights Component Contributor"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = try(var.cr.id, null) != null ? local.identity.ids : {}

  scope                = var.cr.id
  role_definition_name = "AcrPull"
  principal_id         = each.value.principal_id
}
