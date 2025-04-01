variable "allowed_ips" {
  type    = list(string)
  default = []
}

variable "hosting_mode" {
  type    = string
  default = "default"
}

variable "identity" {
  type = list(object({
    id = string
  }))
  default = []
}

variable "name" {
  type = string
}

variable "network_rule_bypass_option" {
  type    = string
  default = "AzureServices"
}

variable "partition_count" {
  type    = number
  default = 1
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

variable "replica_count" {
  type    = number
  default = 0
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
  default = "standard"
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
