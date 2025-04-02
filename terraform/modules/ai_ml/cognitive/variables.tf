/*
  Variable Declaration Order:
  Variables are grouped by logical purpose, not alphabetically.
  This improves readability and matches the structure defined in the module README under "Logical Grouping Order".
*/

# 🔷 Identity / Basic Info
variable "name" {
  type        = string
  description = "Specifies the name of the Azure Cognitive Services Account."
}

variable "rg" {
  type        = any
  description = "The resource group where all module resources will be deployed."
}

# 🔐 Security / Identity
variable "identity_ids" {
  type        = list(string)
  default     = []
  description = "List of User Assigned Identity IDs. If empty, a new identity will be created automatically."
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
  description = "Resource group containing the private DNS zones."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether public network access is enabled for the account."
}

variable "network_acls" {
  type = object({
    bypass         = optional(string)
    default_action = string
    ip_rules       = list(string)
  })
  default = {
    default_action = "Deny"
    ip_rules       = []
  }
  description = "Network ACLs to define access restrictions. Supports IP allow lists and default action policies."
}

# ⚙️ Settings / Config
variable "kind" {
  type        = string
  description = "Kind of the Azure Cognitive Services Account."
}

variable "sku_name" {
  type        = string
  default     = "S0"
  description = "SKU tier for the Azure Cognitive Services Account (e.g., S, S0)."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Tags to apply to all resources"
}
