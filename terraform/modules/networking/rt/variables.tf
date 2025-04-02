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
variable "routes" {
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  description = <<EOT
  Map of route entries to be created in the Route Table. Each entry must include:
  
  - `address_prefix`: The destination CIDR (e.g., "10.0.0.0/16").
  - `next_hop_type`: Type of the next hop (e.g., "VirtualAppliance", "Internet", "VnetLocal").
  - `next_hop_in_ip_address`: Optional. Required if `next_hop_type` is "VirtualAppliance".
  EOT
}

# 🏷️ Tags
variable "tags" {
  type        = map(any)
  description = "Key-value tags to apply to all created resources for cost tracking, governance, and discovery."
}
