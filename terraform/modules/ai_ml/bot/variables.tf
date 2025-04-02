/*
  Variable Declaration Order:
  Variables are grouped by logical purpose, not alphabetically.
  This improves readability and matches the structure defined in the module README under "Logical Grouping Order".
*/

# 🔷 Identity / Basic Info
variable "name" {
  type        = string
  description = "Specifies the name of the Bot Channels Registration. Changing this forces a new resource to be created. Must be globally unique."
}

variable "rg" {
  type        = any
  description = "The resource group where all module resources will be deployed."
}

# 🔐 Security / Identity
variable "application" {
  type = object({
    id = string
  })
  description = "The Microsoft Application ID for the Bot Channels Registration"
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
  description = "Resource group containing the private DNS zones"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is enabled for the Bot Channels Registration"
}

# ⚙️ Settings / Config
variable "sku" {
  type        = string
  default     = "F0"
  description = "SKU tier for Bot Channels Registration (e.g. F0, S1)"
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Tags to apply to all resources"
}
