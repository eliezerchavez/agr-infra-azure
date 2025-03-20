variable "name" {
  type    = string
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

variable "tags" {
  type = map
}

variable "vnet" {
  type = object({
    id = string
    subnet = object({
      id = string
    })
  })
}
