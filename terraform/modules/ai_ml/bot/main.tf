resource "azurerm_bot_channels_registration" "this" {
  name                = var.name
  location            = "global" # https://learn.microsoft.com/en-us/azure/bot-service/bot-builder-concept-regionalization?view=azure-bot-service-4.0
  resource_group_name = var.rg.name

  microsoft_app_id              = var.application.id
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }
}
