locals {
  private_dns_zone = {
    "FormRecognizer" = "privatelink.cognitiveservices.azure.com"
    "OpenAI"         = "privatelink.openai.azure.com"
    "TextAnalytics"  = "privatelink.cognitiveservices.azure.com"
  }

}

data "azurerm_private_dns_zone" "this" {
  name                = local.private_dns_zone[var.kind]
  resource_group_name = var.private_dns_rg

  provider = azurerm.hub
}

resource "azurerm_private_endpoint" "this" {
  name                = "${var.name}-pe"
  location            = var.rg.location
  resource_group_name = var.rg.name

  subnet_id = var.vnet.subnet.id

  private_service_connection {
    name                           = "sc-${var.name}"
    private_connection_resource_id = azurerm_cognitive_account.this.id
    subresource_names              = ["account"]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }

}
