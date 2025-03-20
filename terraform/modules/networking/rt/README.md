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

| Name     | Type           | Required | Default | Description                           |
|----------|----------------|----------|---------|---------------------------------------|
| `name`   | `string`       | Yes      | n/a     | Name of the Route Table.              |
| `rg`     | `object`       | Yes      | n/a     | Resource group configuration.         |
| `routes` | `list(object)` | Yes      | n/a     | Routes to include in the Route Table. |
| `tags`   | `map(any)`     | Yes      | n/a     | Tags assigned to resources.           |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Details of the resource group used for deployment.

| Attribute  | Type     | Required | Default | Description                 |
|------------|----------|----------|---------|-----------------------------|
| `id`       | `string` | Yes      | n/a     | Resource group ID.          |
| `location` | `string` | Yes      | n/a     | Azure region of the group.  |
| `name`     | `string` | Yes      | n/a     | Name of the resource group. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

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

Contributions to enhance module functionality or documentation are welcome. Please open an issue or submit a pull request with your suggestions. Remember to update tests as appropriate.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
