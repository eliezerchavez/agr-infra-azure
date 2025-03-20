<a name="readme-top"></a>

# Terraform Module: Azure Redis Cache

- [Terraform Module: Azure Redis Cache](#terraform-module-azure-redis-cache)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Private Endpoint (`pe`)](#private-endpoint-pe)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [SKU (`sku`)](#sku-sku)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Redis Cache instance with configurable SKU, secure networking through private endpoints, and integration within virtual networks. It is optimized for performance, security, and scalability, suitable for production-grade deployments requiring distributed caching.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

_**Note:** This module requires provider aliases (`azurerm.app`, `azurerm.hub`) if deploying resources across multiple scopes._

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name            | Type       | Required | Default               | Description                          |
|-----------------|------------|----------|-----------------------|--------------------------------------|
| `capacity`      | `number`   | No       | `1`                   | Capacity (SKU size) of Redis Cache.  |
| `family`        | `string`   | No       | `C`                   | SKU family of Redis Cache.           |
| `name`          | `string`   | Yes      | n/a                   | Name of the Redis Cache instance.    |
| `pe`            | `object`   | Yes      | n/a                   | Private endpoint configuration.      |
| `rg`            | `object`   | Yes      | n/a                   | Resource group configuration.        |
| `sku`           | `string`   | No       | `Standard`            | SKU tier for Redis Cache.            |
| `tags`          | `map(any)` | Yes      | n/a                   | Tags assigned to resources.          |
| `vnet`          | `object`   | Yes      | n/a                   | Virtual network and subnet config.   |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Required | Default | Description                               |
|-----------|----------|----------|---------|-------------------------------------------|
| `rg.name` | `string` | Yes      | n/a     | Resource group name for private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details for deploying the Redis Cache.

| Attribute  | Type     | Required | Default | Description                 |
|------------|----------|----------|---------|-----------------------------|
| `id`       | `string` | Yes      | n/a     | Resource group ID.          |
| `location` | `string` | Yes      | n/a     | Azure region of the group.  |
| `name`     | `string` | Yes      | n/a     | Name of the resource group. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### SKU (`sku`)

Specifies the SKU details for Redis Cache.

| Attribute  | Type   | Required | Default    | Description                          |
|------------|--------|----------|------------|--------------------------------------|
| `name`     | string | No       | `Standard` | SKU tier (Basic, Standard, Premium). |
| `family`   | string | No       | `C`        | SKU family.                          |
| `capacity` | number | No       | `1`        | SKU capacity.                        |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Virtual Network (`vnet`)

Virtual network integration details.

| Attribute   | Type     | Required | Default | Description                |
|-------------|----------|----------|---------|----------------------------|
| `id`        | `string` | Yes      | n/a     | Virtual Network ID.        |
| `subnet.id` | `string` | Yes      | n/a     | Subnet ID within the VNet. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module is composed of the following files:

- **main.tf**:  
  Contains primary resource definitions for Azure Redis Cache and private endpoints.

- **variables.tf**:  
  Declares all input variables required by the module.

- **outputs.tf**:  
  Defines outputs for integration into downstream configurations.

- **provider.tf**:  
  Configures AzureRM provider and necessary aliases for multi-scope deployments.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "redis" {
  source = "../../modules/databases/redis"
  name   = format("redis-%s-%s", var.platform, var.env)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-DATABASES"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                              |
|--------|------------------------------------------|
| `id`   | ID of the Azure Redis Cache instance.    |
| `name` | Name of the Azure Redis Cache instance.  |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

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

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
