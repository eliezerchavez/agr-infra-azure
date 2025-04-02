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
    id   = string
    name = string
  })
  description = "Virtual Network input that includes the subnet to be used for Private Endpoint or service-level integration."
}

variable "address_prefix" {
  type        = string
  description = "The address prefix (CIDR block) to assign to the subnet (e.g., '10.0.1.0/24')."
}

# ⚙️ Settings / Config
variable "service_endpoints" {
  type        = list(string)
  default     = []
  description = "List of service endpoints to associate with the subnet (e.g., 'Microsoft.Storage')."
}

variable "delegations" {
  type = map(object({
    service_delegation = object({
      actions = list(string)
      name    = string
    })
  }))
  default     = {}
  description = "Map of service delegations to apply to the subnet. Each item must define the `name` and allowed `actions`."
}
