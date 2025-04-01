variable "cr" {
  type = object({
    id = optional(string)
  })
  default = {}
}

variable "kv" {
  type = object({
    id = optional(string)
  })
  default = {}
}

variable "name" {
  type = string
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

variable "storage" {
  type = object({
    id = optional(string)
  })
  default = {}
}

variable "tags" {
  type = map(any)
}

variable "upgrade_channel" {
  type = object({
    automatic = string
    node_os   = string
  })
  default = {
    automatic = "stable"
    node_os   = "None"
  }
}

variable "vnet" {
  type = object({
    id = string
    subnet = object({
      id = string
    })
    route_table = object({
      id = string
    })
  })
}
