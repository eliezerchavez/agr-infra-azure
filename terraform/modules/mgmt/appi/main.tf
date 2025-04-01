module "log" {
  count = try(var.log.id, null) != null ? 0 : 1

  source = "../log"

  name = "${var.name}-log"

  rg = var.rg

  tags = var.tags

}

resource "azurerm_application_insights" "this" {
  name                = var.name
  location            = var.rg.location
  resource_group_name = var.rg.name

  application_type = var.application_type
  workspace_id     = try(var.log.id, null) != null ? var.log.id : module.log[0].id

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }

}
