variable "appi" {
  type = object({
    id = string
  })

}

variable "cr" {
  type = object({
    id = optional(string)
  })
  
}

variable "identity" {
  type = list(object({
    id = string
  }))
  default = []
}

variable "kv" {
  type = object({
    id = string
  })

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
  default = true

}

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "sku_name" {
  type    = string
  default = "S0"
}

variable "storage" {
  type = object({
    id = optional(string)
  })

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
