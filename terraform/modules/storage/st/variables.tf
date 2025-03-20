variable "account" {
  type = object({
    kind = string
    replication_type = string
    tier = string
  })
  default = {
    kind = "StorageV2"
    replication_type = "ZRS"
    tier = "Standard"
  }
}

variable "name" {
  type = string
}

variable "containers" {
  type    = list(string)
  default = []
}

variable "pe" {
  type = object({
    rg = object({
      name = string
    })
  })
}

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "shares" {
  type = map(object({
    quota = optional(number)
  }))
  default = {}
}

# variable "static_website" {
#   type = bool
#   default = false
# }

variable "subresource_names" {
  type    = list(string)
  default = ["blob"]
}

variable "tags" {
  type = map(any)
  default = {
    "Criticality"   = "Mission-Critical"
    "BusinessUnit"  = "Shared"
    "OpsCommitment" = "Workload operations"
    "OpsTeam"       = "Cloud operations"
  }
}

variable "vnet" {
  type = object({
    id = string
    subnet = object({
      id = string
    })
  })
}
