output "credentials" {
  value = {
    username = azurerm_postgresql_flexible_server.this.administrator_login
    password = azurerm_postgresql_flexible_server.this.administrator_password
  }
}

output "id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "name" {
  value = azurerm_postgresql_flexible_server.this.name
}
