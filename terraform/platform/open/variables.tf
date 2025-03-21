variable "business_unit" {
  type        = string
  description = "Specifies the Avangrid business unit for which resources are being provisioned. Valid values are 'corporate', 'networks', or 'renewables'."
  validation {
    condition     = contains(["corporate", "networks", "renewables"], var.business_unit)
    error_message = "The business_unit variable must be one of 'corporate', 'networks', or 'renewables'."
  }
  default = "corporate"
}

variable "env" {
  type        = string
  description = "Deployment environment of the application, workload, or service. Valid values are 'dev', 'qat', or 'prd'."
  validation {
    condition     = contains(["dev", "qat", "prd"], var.env)
    error_message = "The env variable must be one of 'dev', 'qat', or 'prd'."
  }
  default = "dev"
}

variable "location" {
  type        = string
  description = "The location/region to keep all your network resources. Valid values are 'eastus', or 'westus2'."
  validation {
    condition     = contains(["eastus", "westus2"], var.location)
    error_message = "The location variable must be one of 'eastus' or 'westus2'."
  }
  default = "eastus"
}

variable "net" {
  type = object({
    snet = object({
      address_prefix = string
    })
    rt = object({
      routes = map(object({
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = optional(string)
      }))
    })
  })
}

variable "platform" {
  type        = string
  description = "(Required) The name of the platform hosting multiple applications. This value is used to identify the resource group and all associated resources within the platform."
}
