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
variable "identity_ids" {
  type        = list(string)
  default     = []
  description = "List of User Assigned Managed Identity IDs to assign to the resource. If empty, a new identity may be created."
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

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether the resource allows public network access."
}

# ⚙️ Settings / Config
variable "kind" {
  type = string
  validation {
    condition     = contains(["FormRecognizer", "OpenAI", "TextAnalytics"], var.kind)
    error_message = "The kind variable must be one of 'FormRecognizer', 'OpenAI', or 'TextAnalytics'."
  }
  description = "Kind of the Azure Cognitive Services Account. Must be one of 'FormRecognizer', 'OpenAI' or 'TextAnalytics'."

}

variable "sku_name" {
  type        = string
  default     = "S0"
  description = "The SKU tier for the resource (e.g., Standard, Premium). Use specific object if additional options are needed."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
