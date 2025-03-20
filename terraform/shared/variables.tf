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
  description = "Deployment environment of the application, workload, or service. Valid values are 'dev', 'npd', 'prd', or 'qat'."
  validation {
    condition     = contains(["dev", "npd", "prd", "qat"], var.env)
    error_message = "The env variable must be one of 'dev', 'npd', 'prd', or 'qat'."
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
