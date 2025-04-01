variable "daily_quota_gb" {
  type = number
  default = -1
}

variable "name" {
  type = string
}

variable "retention_in_days" {
  type    = number
  default = 30
}

variable "rg" {
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "sku" {
  type        = string
  default     = "PerGB2018"
  description = "The SKU of the Log Analytics Workspace. Valid options: Free, PerNode, PerGB2018, Standalone, CapacityReservation, LACluster."
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
