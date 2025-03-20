variable "admin_enabled" {
  type    = bool
  default = true
}

variable "georeplications" {
  type = list(object({
    location                  = string
    regional_endpoint_enabled = bool
    zone_redundancy_enabled   = bool
  }))
  default = [{
    location                  = "westus2"
    regional_endpoint_enabled = false
    zone_redundancy_enabled   = true
  }]
}

variable "name" {
  type = string
}

variable "pe" {
  type = object({
    rg = object({
      name = string
    })
  })
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "sku" {
  type    = string
  default = "Premium"
}

variable "tags" {
  type = map(any)
}

variable "vnet" {
  type = object({
    id = string
    subnet = object({
      id = string
    })
  })
}
