<a name="readme-top"></a>

# Terraform Module: Azure Route Table

- [Terraform Module: Azure Route Table](#terraform-module-azure-route-table)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Routes (`routes`)](#routes-routes)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Route Table and associated routes, providing a centralized management solution for network traffic routing within Azure Virtual Networks (VNets). It is designed for clarity, maintainability, and scalability in network management tasks.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name     | Type          | Required | Default | Description                           |
|----------|---------------|----------|---------|---------------------------------------|
| `name`   | `string`      | Yes      | n/a     | Name of the Route Table.              |
| `rg`     | `object`      | Yes      | n/a     | Resource group configuration.         |
| `routes` | `map(object)` | Yes      | n/a     | Routes to include in the Route Table. |
| `tags`   | `map(any)`    | Yes      | n/a     | Tags assigned to resources.           |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

The full Azure Resource Group object. This variable is passed from a data source or parent module.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

### Routes (`routes`)

Configuration for individual routes.

| Attribute                | Type     | Required | Default | Description                                        |
|--------------------------|----------|----------|---------|----------------------------------------------------|
| `name`                   | `string` | Yes      | n/a     | Name of the route.                                 |
| `address_prefix`         | `string` | Yes      | n/a     | Destination CIDR of the route.                     |
| `next_hop_type`          | `string` | Yes      | n/a     | Next hop type (e.g., VirtualAppliance, VnetLocal). |
| `next_hop_in_ip_address` | `string` | No       | n/a     | Next hop IP address if applicable.                 |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module is composed of the following files:

- **main.tf**:  
  Contains primary definitions for the Azure Route Table and route resources.

- **variables.tf**:  
  Declares all input variables required by the module.

- **outputs.tf**:  
  Defines outputs, such as route table ID and name, for use in downstream configurations.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "rt" {
  source = "../../modules/networking/rt"

  name = format("${local.vnet.name}-UDR-AKS-%s-%s", upper(var.platform), upper(var.env))

  rg = local.vnet.rg

  routes = var.net.rt.routes

  tags = local.tags

}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                          |
|--------|--------------------------------------|
| `id`   | ID of the Azure Route Table.         |
| `name` | Name of the Azure Route Table.       |

---

## Contributing

Contributions to enhance the module’s functionality or documentation are welcome. Please open an issue or submit a pull request with your suggestions. Remember to update tests as appropriate.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Development Guidelines

### Logical Grouping Order

| Group                    | Example Fields                                                           |
|--------------------------|--------------------------------------------------------------------------|
| 🔷 Identity / Basic Info | `name`, `location`, `resource_group_name`                                |
| 🔐 Security / Identity   | `identity`, `key_vault_id`, `application_insights_id`, etc.              |
| 🌐 Networking            | `vnet`, `subnet_id`, `private_endpoint`, `public_network_access_enabled` |
| ⚙️ Settings / Config     | `sku`, `app_id`, `custom_subdomain_name`, `settings`, etc.               |
| 🏷️ Tags                  | `tags`                                                                   |
| 🔁 Lifecycle             | `lifecycle`, `depends_on`                                                |

> This grouping helps maintain readability and aligns with Azure best practices for resource declarations.

### Variable Declaration Strategy

Variables are intentionally grouped by purpose, not listed alphabetically. This logical ordering improves readability and aligns with the resource layout in the Terraform code itself.

| Group                    | Purpose                                                               |
|--------------------------|-----------------------------------------------------------------------|
| 🔷 Identity / Basic Info | Basic resource identifiers and scope (e.g., `name`, `rg`)             |
| 🔐 Security / Identity   | Identity configuration, Microsoft App IDs, Key Vault, etc.            |
| 🌐 Networking            | Network-related inputs like `vnet`, `subnet`, Private DNS, endpoints  |
| ⚙️ Settings / Config     | Configuration options like SKU, versioning, and app-specific settings |
| 🏷️ Tags                  | Tags used for governance, cost control, or discovery                  |

This grouping also matches the field order used in resource blocks, helping teams onboard quickly and reducing cognitive load.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") – _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
