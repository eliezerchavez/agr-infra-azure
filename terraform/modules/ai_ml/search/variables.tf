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

variable "allowed_ips" {
  type    = list(string)
  default = []
}

variable "network_rule_bypass_option" {
  type    = string
  default = "AzureServices"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is enabled for the workspace."
}

# ⚙️ Settings / Config
variable "hosting_mode" {
  type    = string
  default = "default"
}

variable "partition_count" {
  type    = number
  default = 1
}

variable "replica_count" {
  type    = number
  default = 0
}

variable "sku" {
  type    = string
  default = "standard"
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
