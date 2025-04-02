resource "time_sleep" "wait_for_iam" {
  depends_on      = [azurerm_role_assignment.key_vault_reader]
  create_duration = "60s"
}

resource "azurerm_machine_learning_workspace" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : [azurerm_user_assigned_identity.this[0].id]
  }
  primary_user_assigned_identity = length(var.identity_ids) > 0 ? var.identity_ids[0] : azurerm_user_assigned_identity.this[0].id
  key_vault_id                   = var.kv.id

  public_network_access_enabled = var.public_network_access_enabled

  kind                    = var.kind
  sku_name                = var.sku_name
  application_insights_id = var.appi.id
  container_registry_id   = try(var.cr.id, null)
  storage_account_id      = var.storage.id

  tags = var.tags

  lifecycle {
ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

  depends_on = [
    azurerm_role_assignment.key_vault_reader,
    azurerm_role_assignment.storage_blob_data_contributor,
    azurerm_role_assignment.application_insights_component_contributor,
    azurerm_role_assignment.acr_pull
  ]
}
