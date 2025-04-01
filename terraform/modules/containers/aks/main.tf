locals {
  node_pool = {
    default = {
      auto_scaling = {
        enabled   = var.node_pool.default.auto_scaling != null ? var.node_pool.default.auto_scaling.enabled : true
        max_count = var.node_pool.default.auto_scaling != null ? coalesce(var.node_pool.default.auto_scaling.max_count, coalesce(var.node_pool.default.node_count, 2)) : coalesce(var.node_pool.default.node_count, 2)
        min_count = var.node_pool.default.auto_scaling != null ? coalesce(var.node_pool.default.auto_scaling.min_count, coalesce(var.node_pool.default.node_count, 2)) : coalesce(var.node_pool.default.node_count, 2)
      }
      node_count = coalesce(var.node_pool.default.node_count, 2)
      vm_size    = var.node_pool.default.vm_size
    }
    additional = { for key, value in var.node_pool.additional :
      key => {
        auto_scaling = {
          enabled   = value.auto_scaling != null ? value.auto_scaling.enabled : true
          max_count = value.auto_scaling != null ? coalesce(value.auto_scaling.max_count, coalesce(value.node_count, 2)) : coalesce(value.node_count, 2)
          min_count = value.auto_scaling != null ? coalesce(value.auto_scaling.min_count, coalesce(value.node_count, 2)) : coalesce(value.node_count, 2)
        }
        node_count = coalesce(value.node_count, 2)
        vm_size    = value.vm_size
      }
    }
  }
}

data "azurerm_client_config" "current" {
  provider = azurerm.app

}

data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.${var.rg.location}.azmk8s.io"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "id-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  provider = azurerm.app

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_role_assignment" "private_dns_zone" {
  scope                = data.azurerm_private_dns_zone.this.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id

  lifecycle {
    ignore_changes = [scope]
  }

}

resource "azurerm_role_assignment" "route_table" {
  scope                = var.vnet.route_table.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id

}

resource "azurerm_role_assignment" "subnet" {
  scope                = var.vnet.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id

}

resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = var.kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id

}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = var.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id

}

resource "azurerm_role_assignment" "storage" {
  scope                = var.storage.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_user_assigned_identity.this.principal_id

}

resource "azurerm_kubernetes_cluster" "this" {
  name = var.name

  location            = var.rg.location
  resource_group_name = var.rg.name

  automatic_upgrade_channel           = var.upgrade_channel.automatic
  azure_policy_enabled                = true
  dns_prefix                          = var.name
  node_os_upgrade_channel             = var.upgrade_channel.node_os
  node_resource_group                 = "rg-${var.name}"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  private_dns_zone_id                 = data.azurerm_private_dns_zone.this.id
  # sku_tier                            = "Premium"

  default_node_pool {
    auto_scaling_enabled = local.node_pool.default.auto_scaling.enabled
    name                 = "default"
    max_count            = local.node_pool.default.auto_scaling.max_count
    min_count            = local.node_pool.default.auto_scaling.min_count
    node_count           = local.node_pool.default.node_count
    vm_size              = local.node_pool.default.vm_size
    vnet_subnet_id       = var.vnet.subnet.id
    zones                = ["1", "2", "3"]

    upgrade_settings {
      max_surge = "10%"
    }

  }

  azure_active_directory_role_based_access_control {
    tenant_id = data.azurerm_client_config.current.tenant_id

  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]

  }

  maintenance_window_node_os {
    frequency  = "Daily"
    interval   = 2
    duration   = 8
    start_time = "21:00"
    utc_offset = "-05:00"

  }

  maintenance_window_auto_upgrade {
    frequency   = "RelativeMonthly"
    interval    = 3
    duration    = 6
    day_of_week = "Tuesday"
    start_time  = "21:00"
    utc_offset  = "-05:00"
    week_index  = "Last"

  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
    dns_service_ip = "192.168.128.10"
    pod_cidr       = "192.168.0.0/17"
    service_cidr   = "192.168.128.0/17"
    
  }

  tags = var.tags

  depends_on = [azurerm_role_assignment.private_dns_zone]

  provider = azurerm.app

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count, private_dns_zone_id, tags]
  }

}

resource "azurerm_role_assignment" "cr" {
  count = try(var.cr.id, null) != null ? 1 : 0

  scope                = var.cr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.this]

}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = coalesce(var.node_pool.additional, {})

  auto_scaling_enabled  = local.node_pool.additional[each.key].auto_scaling.enabled
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  max_count             = local.node_pool.additional[each.key].auto_scaling.max_count
  min_count             = local.node_pool.additional[each.key].auto_scaling.min_count
  name                  = each.key
  node_count            = local.node_pool.additional[each.key].node_count
  vm_size               = local.node_pool.additional[each.key].vm_size
  vnet_subnet_id        = var.vnet.subnet.id
  zones                 = ["1", "2", "3"]

  tags = var.tags

  lifecycle {
    ignore_changes = [node_count, tags]
  }

}
