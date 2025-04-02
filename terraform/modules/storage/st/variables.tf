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

variable "subresource_names" {
  type        = list(string)
  default     = ["blob"]
  description = "List of Storage Account subresource types to associate with the private endpoint (e.g., blob, file, table, queue)."
}

# ⚙️ Settings / Config
variable "account" {
  type = object({
    kind             = string
    replication_type = string
    tier             = string
  })
  default = {
    kind             = "StorageV2"
    replication_type = "ZRS"
    tier             = "Standard"
  }
  description = "Configuration for the Storage Account, including kind (e.g., StorageV2), replication type (e.g., LRS, ZRS), and access tier (Hot/Cold)."
}

variable "containers" {
  type        = list(string)
  default     = []
  description = "List of blob containers to create within the Storage Account."
}

variable "shares" {
  type = map(object({
    quota = optional(number)
  }))
  default     = {}
  description = "Map of file shares to create, with optional quota per share (in GB)."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
