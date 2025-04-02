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

variable "kv" {
  type = object({
    id = optional(string)
  })
  default     = {}
  description = "Optional Azure Key Vault to integrate with the AKS cluster for secure secret access."
}

variable "cr" {
  type = object({
    id = optional(string)
  })
  default     = {}
  description = "Optional Azure Container Registry (ACR) object used to allow AKS to pull container images."
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

variable "rt" {
  type = object({
    id = string
  })
}

variable "private_dns_rg" {
  type        = string
  default     = "RG-COMMON-NETWORKING-AZDNS"
  description = "Name of the resource group that contains the Private DNS Zones."
}

# ⚙️ Settings / Config
variable "upgrade_channel" {
  type = object({
    automatic = string
    node_os   = string
  })
  default = {
    automatic = "stable"
    node_os   = "None"
  }
  description = "Specifies the upgrade channel for AKS. Options include `stable`, `rapid`, `patch`, and `node-image`."
}

variable "node_pool" {
  type = object({
    default = object({
      auto_scaling = optional(object({
        enabled   = bool
        max_count = number
        min_count = number
      }))
      node_count = optional(number)
      vm_size    = string
    })
    additional = optional(map(object({
      auto_scaling = optional(object({
        enabled   = bool
        max_count = number
        min_count = number
      }))
      node_count = optional(number)
      vm_size    = string
    })))
  })
  default = {
    default = {
      vm_size = "Standard_D2s_v5"
    }
  }
  description = "Configuration block for the AKS default node pool. Supports additional custom node pools as an optional list."
}

variable "storage" {
  type = object({
    id = string
  })
  description = "Optional Azure Storage Account to be used by the AKS cluster for persistent storage needs."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
