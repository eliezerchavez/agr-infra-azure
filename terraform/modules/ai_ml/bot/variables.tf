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
variable "application" {
  type = object({
    id = string
  })
  description = "The Microsoft Application ID for the Bot Channels Registration."
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
  default     = "F0"
  description = "The SKU tier for the resource (e.g., Standard, Premium). Use specific object if additional options are needed."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
