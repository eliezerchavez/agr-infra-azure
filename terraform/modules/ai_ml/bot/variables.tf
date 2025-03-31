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
  type    = string
  default = "F0"
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
