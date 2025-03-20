variable "name" {
  type = string
}

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "routes" {
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
}

variable "tags" {
  type = map(any)
}
