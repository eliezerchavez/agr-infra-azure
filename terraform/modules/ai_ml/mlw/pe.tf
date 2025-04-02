data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.api.azureml.ms"
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
    private_connection_resource_id = azurerm_machine_learning_workspace.this.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false

  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-${var.name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]

  }

  tags = var.tags

  lifecycle {
ignore_changes = [tags["CreatedAt"], tags["CREATOR"]]
  }

}
