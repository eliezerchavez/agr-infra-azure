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

  name                = "${var.name}-id"
  location            = var.rg.location
  resource_group_name = var.rg.name

  provider = azurerm.app

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }
}

resource "azurerm_role_assignment" "private_dns_zone_contributor" {
  for_each = local.identity.ids

  scope                = data.azurerm_private_dns_zone.this.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = each.value.principal_id

  lifecycle {
    ignore_changes = [scope]
  }
}

resource "azurerm_role_assignment" "rt_network_contributor" {
  for_each = local.identity.ids

  scope                = var.rt.id
  role_definition_name = "Network Contributor"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "subnet_network_contributor" {
  for_each = local.identity.ids

  scope                = var.vnet.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "key_vault_reader" {
  for_each = local.identity.ids

  scope                = var.kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  for_each = local.identity.ids

  scope                = var.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "reader_and_data_access" {
  for_each = local.identity.ids

  scope                = var.storage.id
  role_definition_name = "Reader and Data Access"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = try(var.cr.id, null) != null ? local.identity.ids : {}

  scope                = var.cr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.this]
}
