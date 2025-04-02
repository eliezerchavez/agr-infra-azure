/*
  Variable Declaration Order:
  Variables are grouped by logical purpose, not alphabetically.
  This improves readability and matches the structure defined in the module README under "Logical Grouping Order".
*/

# 🔷 Identity / Basic Info
variable "name" {
  type        = string
  description = "Specifies the name of the Azure Machine Learning Workspace. Must be globally unique within the subscription."
}

variable "rg" {
  type        = any
  description = "The resource group where all module resources will be deployed."
}

# ⚙️ Settings / Config

variable "application_type" {
  type    = string
  default = "web"
}

variable "log" {
  type = object({
    id = optional(string)
  })
  default = {}

}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}

