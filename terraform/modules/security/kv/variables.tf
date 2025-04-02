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
variable "enabled_for_disk_encryption" {
  type        = bool
  default     = true
  description = "Whether the resource is enabled for disk encryption."
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = true
  description = "Whether to enable Role-Based Access Control (RBAC) for this resource."
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "The soft_delete_retention_days variable must be between 7 and 90."
  }

  description = "The number of days that soft-deleted resources will be retained before permanent deletion. Must be between 7 and 90 days, inclusive."
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Whether purge protection is enabled to prevent immediate deletion of soft-deleted resources."
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

variable "sku_name" {
  type    = string
  default = "premium"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The sku_name variable must be one of 'standard' or 'premium'."
  }
  description = "The SKU tier for the resource (e.g., Standard, Premium). Use specific object if additional options are needed."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
