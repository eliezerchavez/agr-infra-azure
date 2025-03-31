data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = var.pe.rg.name

  provider = azurerm.hub
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "id-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_cognitive_account" "this" {
  name = var.name

  location            = var.rg.location
  resource_group_name = var.rg.name

  kind     = var.kind
  sku_name = var.sku_name

  custom_subdomain_name = replace(replace(var.name, "oai-", ""), "-", "")

  network_acls {
    bypass         = var.network_acls.bypass
    default_action = var.network_acls.default_action
    ip_rules       = var.network_acls.ip_rules
  }

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }


}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-${var.name}"
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.vnet.subnet.id

  tags = var.tags

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

  lifecycle {
    ignore_changes = [tags]
  }

}
