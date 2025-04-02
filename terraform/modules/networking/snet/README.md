<a name="readme-top"></a>

# Terraform Module: Azure Subnet

- [Terraform Module: Azure Subnet](#terraform-module-azure-subnet)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Delegation (`delegation`)](#delegation-delegation)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Service Endpoints (`service_endpoints`)](#service-endpoints-service_endpoints)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions Azure Subnets within an existing Virtual Network (VNet), with optional delegation and service endpoints settings. It simplifies network segmentation and management tasks while ensuring compliance with best practices.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                | Type          | Required | Default | Description                      |
|---------------------|---------------|----------|---------|----------------------------------|
| `delegation`        | `object`      | No       | n/a     | Delegation configuration.        |
| `name`              | `string`      | Yes      | n/a     | Name of the subnet.              |
| `prefixes`          | `list(string)`| Yes      | n/a     | Address prefixes for the subnet. |
| `rg`                | `object`      | Yes      | n/a     | Resource group configuration.    |
| `service_endpoints` | `list(string)`| No       | n/a     | List of service endpoints.       |
| `tags`              | `map(any)`    | Yes      | n/a     | Tags assigned to resources.      |
| `vnet`              | `object`      | Yes      | n/a     | Virtual network configuration.   |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Delegation (`delegation`)

Optional configuration for subnet delegation.

| Attribute     | Type           | Required | Default | Description                                  |
|---------------|----------------|----------|---------|----------------------------------------------|
| `name`        | `string`       | Yes      | n/a     | Name of the delegation service.              |
| `actions`     | `list(string)` | Yes      | n/a     | List of actions permitted by the delegation. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Full Azure Resource Group object. This variable is passed as-is from a data source or parent module output.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

### Virtual Network (`vnet`)

Virtual network details for the subnet.

| Attribute   | Type     | Required | Default | Description                |
|-------------|----------|----------|---------|----------------------------|
| `id`        | `string` | Yes      | n/a     | Virtual Network ID.        |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module is composed of the following files:

- **main.tf**:  
  Contains primary definitions for Azure Subnet resources.

- **variables.tf**:  
  Declares all input variables required by the module.

- **outputs.tf**:  
  Defines outputs such as subnet ID and name for downstream configurations.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "snet" {
  source = "../../modules/networking/snet"

  address_prefix = var.net.snet.address_prefix

  name = format("${local.vnet.name}-SNET-AKS-%s-%s", upper(var.platform), upper(var.env))

  rg = local.vnet.rg

  service_endpoints = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]

  vnet = {
    id   = local.vnet.id
    name = local.vnet.name
  }

}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                  |
|--------|------------------------------|
| `id`   | ID of the Azure Subnet.      |
| `name` | Name of the Azure Subnet.    |

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
