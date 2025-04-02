/*
  Variable Declaration Order:
  Variables are grouped by logical purpose, not alphabetically.
  This improves readability and matches the structure defined in the module README under "Logical Grouping Order".
*/

# 🔷 Identity / Basic Info
variable "name" {
  type        = string
  description = "Specifies the name of the resource. Must be unique within the scope of the deployment."
}

variable "rg" {
  type        = any
  description = "The full Resource Group object where the resource(s) will be deployed. Expected to include 'name' and 'location'."
}

# ⚙️ Settings / Config

variable "application_type" {
  type        = string
  default     = "web"
  description = "The type of Application Insights to create. Common values are 'web', 'other', 'node.js'."
}

variable "workspace" {
  type = object({
    id = optional(string)
  })
  default     = {}
  description = "The ID of the Log Analytics Workspace to link this Application Insights instance to."
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}

