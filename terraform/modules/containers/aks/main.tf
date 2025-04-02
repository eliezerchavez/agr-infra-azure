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

data "azurerm_client_config" "current" {}

data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.${var.rg.location}.azmk8s.io"
  resource_group_name = var.private_dns_rg

  provider = azurerm.hub
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  identity {
    type         = "UserAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : [azurerm_user_assigned_identity.this[0].id]
  }

  azure_active_directory_role_based_access_control {
    tenant_id = data.azurerm_client_config.current.tenant_id
  }

  dns_prefix          = var.name
  private_dns_zone_id = data.azurerm_private_dns_zone.this.id

  automatic_upgrade_channel           = var.upgrade_channel.automatic
  azure_policy_enabled                = true
  node_os_upgrade_channel             = var.upgrade_channel.node_os
  node_resource_group                 = "rg-${var.name}"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  # sku_tier                          = "Premium"

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

  depends_on = [
    azurerm_role_assignment.private_dns_zone_contributor,
    azurerm_role_assignment.reader_and_data_access,
    azurerm_role_assignment.rt_network_contributor,
    azurerm_role_assignment.subnet_network_contributor
  ]

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count, private_dns_zone_id, tags["CreatedAt"], tags["CREATOR"]]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = coalesce(var.node_pool.additional, {})

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vnet_subnet_id = var.vnet.subnet.id

  auto_scaling_enabled = local.node_pool.additional[each.key].auto_scaling.enabled
  max_count            = local.node_pool.additional[each.key].auto_scaling.max_count
  min_count            = local.node_pool.additional[each.key].auto_scaling.min_count
  node_count           = local.node_pool.additional[each.key].node_count
  vm_size              = local.node_pool.additional[each.key].vm_size
  zones                = ["1", "2", "3"]

  tags = var.tags

  lifecycle {
    ignore_changes = [node_count, tags["CreatedAt"], tags["CREATOR"]]
  }
}
