variable "application_type" {
  type    = string
  default = "web"
}

variable "log" {
  type = object({
    id = optional(string)
  })

}

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

variable "tags" {
  type = map(any)
  default = {
    "Criticality"   = "Mission-Critical"
    "BusinessUnit"  = "Shared"
    "OpsCommitment" = "Workload operations"
    "OpsTeam"       = "Cloud operations"
  }
}
