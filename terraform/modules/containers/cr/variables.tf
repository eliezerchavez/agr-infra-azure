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

# 🔐 Security / Identity
variable "admin_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the admin user account is enabled on the ACR. Recommended to keep disabled in production environments."
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
  type        = string
  default     = "Premium"
  description = "The SKU tier for the resource (e.g., Standard, Premium). Use specific object if additional options are needed."
}

variable "georeplications" {
  type = list(object({
    location                  = string
    regional_endpoint_enabled = bool
    zone_redundancy_enabled   = bool
  }))
  default = [{
    location                  = "westus2"
    regional_endpoint_enabled = false
    zone_redundancy_enabled   = true
  }]
  description = "List of geo-replication configurations. Each entry defines the replica region, endpoint exposure, and zone redundancy support."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
