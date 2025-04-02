/*
  Variable Declaration Order:
  Variables are grouped by logical purpose, not alphabetically.
  This improves readability and matches the structure defined in the module README under "Logical Grouping Order".
*/

# 🔷 Identity / Basic Info
variable "name" {
  type        = string
  description = "Specifies the name of the Azure Machine Learning Workspace. Must be globally unique within the subscription."
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

variable "kv" {
  type = object({
    id = string
  })
  description = "Key Vault used for secret management by the ML Workspace."
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
  description = "Whether public network access is enabled for the workspace."
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
  default     = "Default"
  description = "Kind of the Azure Machine Learning Workspace."
}

variable "sku_name" {
  type        = string
  default     = "Basic"
  description = "SKU tier for the Azure Machine Learning Workspace (e.g., Basic, Enterprise)."
}

variable "appi" {
  type = object({
    id = string
  })
  description = "Application Insights resource used for monitoring and diagnostics."
}

variable "cr" {
  type = object({
    id = optional(string)
  })
  default     = {}
  description = "Optional Azure Container Registry (ACR) resource. If not provided, ACR integration will be skipped."
}

variable "storage" {
  type = object({
    id = string
  })
  description = "Azure Storage Account used by the Azure ML Workspace."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
