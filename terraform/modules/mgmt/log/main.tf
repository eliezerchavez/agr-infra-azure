resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  daily_quota_gb    = var.daily_quota_gb
  retention_in_days = var.retention_in_days
  sku               = var.sku

  tags = var.tags

  lifecycle {
ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}
