variable "identity" {
  type = list(object({
    id = string
  }))
  default = []
}

variable "kind" {
  type = string
}

variable "name" {
  type = string
}

variable "network_acls" {
  type = object({
    bypass         = string
    default_action = string
    ip_rules       = list(string)
  })
  default = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = []
  }
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
