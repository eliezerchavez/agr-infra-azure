variable "address_prefix" {
  type = string
}

variable "delegations" {
  type = map(object({
    service_delegation = object({
      actions = list(string)
      name    = string
    })
  }))
  default = {}
}

variable "name" {
  type = string
}

variable "service_endpoints" {
  type    = list(string)
  default = []
}

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "vnet" {
  type = object({
    id = string
    name = string
  })
}
