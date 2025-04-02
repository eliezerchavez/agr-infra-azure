/*
  Variable Declaration Order:
  Variables are grouped by logical purpose, not alphabetically.
  This improves readability and matches the structure defined in the module README under "Logical Grouping Order".
*/

# 🔷 Identity / Basic Info
variable "name" {
  type        = string
  description = "Specifies the name of the resource. Must be unique within the scope of the deployment."
}

variable "rg" {
  type        = any
  description = "The full Resource Group object where the resource(s) will be deployed. Expected to include 'name' and 'location'."
}

# 🌐 Networking
variable "vnet" {
  type = object({
    subnet = object({
      id = string
    })
  })
  description = "Virtual Network input that includes the subnet to be used for Private Endpoint or service-level integration."
}

variable "private_dns_rg" {
  type        = string
  default     = "RG-COMMON-NETWORKING-AZDNS"
  description = "Name of the resource group that contains the Private DNS Zones."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether the resource allows public network access."
}

# ⚙️ Settings / Config
variable "sku" {
  type = object({
    capacity = number
    family   = string
    name     = string
  })
  default = {
    capacity = 1
    family   = "P"
    name     = "Premium"
  }
  description = <<EOT
    Specifies the SKU configuration for the Azure Redis Cache instance. This includes:
    
    - `name`: The SKU name or pricing tier (e.g., Basic, Standard, Premium).
    - `family`: The SKU family (e.g., "C" for Basic/Standard, "P" for Premium).
    - `capacity`: The numeric capacity value representing the size of the Redis instance (e.g., 0–6 for Premium).
  EOT
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
