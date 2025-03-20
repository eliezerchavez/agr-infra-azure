variable "admin" {
  type = object({
    password = optional(string)
    username = string
  })
  default = {
    username = "postgres"
  }
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

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "sku" {
  type = object({
    capacity = number
    family   = string
    name     = string
  })
  default = {
    capacity = 1
    family   = "P"
    name     = "Premium"
  }

}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "tags" {
  type = map(any)
}

variable "ver" {
  type    = string
  default = "16"
}

variable "vnet" {
  type = object({
    id = string
    subnet = object({
      id = string
    })
  })
}
