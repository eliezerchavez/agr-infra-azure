<a name="readme-top"></a>

# Terraform Module: Azure PostgreSQL Flexible Server

- [Terraform Module: Azure PostgreSQL Flexible Server](#terraform-module-azure-postgresql-flexible-server)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Administrator (`admin`)](#administrator-admin)
    - [Private Endpoint (`pe`)](#private-endpoint-pe)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure PostgreSQL Flexible Server with configurable administrator credentials, secure network settings via private endpoints, and integration into virtual networks. It is optimized for secure, highly available, and scalable PostgreSQL deployments in production environments.

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
| `admin`         | `object`   | No       | See below             | Administrator credentials for server.|
| `name`          | `string`   | Yes      | n/a                   | Name of the PostgreSQL server.       |
| `pe`            | `object`   | Yes      | n/a                   | Private endpoint configuration.      |
| `rg`            | `object`   | Yes      | n/a                   | Resource group configuration.        |
| `sku_name`      | `string`   | No       | `GP_Standard_D2ds_v5` | SKU tier for PostgreSQL server.      |
| `storage_mb`    | `number`   | No       | `32768`               | Storage capacity in MB.              |
| `tags`          | `map(any)` | Yes      | n/a                   | Tags assigned to resources.          |
| `ver`           | `string`   | No       | `16`                  | PostgreSQL version.                  |
| `vnet`          | `object`   | Yes      | n/a                   | Virtual network and subnet config.   |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Administrator (`admin`)

| Attribute  | Type     | Required | Default            | Description                    |
|------------|----------|----------|--------------------|--------------------------------|
| `username` | `string` | Yes      | `postgres`         | Username for admin account.    |
| `password` | `string` | No       | Randomly Generated | Password for admin account.    |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Required | Default | Description                               |
|-----------|----------|----------|---------|-------------------------------------------|
| `rg.name` | `string` | Yes      | n/a     | Resource group name for private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details for deploying the server.

| Attribute  | Type     | Required | Default | Description                 |
|------------|----------|----------|---------|-----------------------------|
| `id`       | `string` | Yes      | n/a     | Resource group ID.          |
| `location` | `string` | Yes      | n/a     | Azure region of the group.  |
| `name`     | `string` | Yes      | n/a     | Name of the resource group. |

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
  Contains the primary resource definitions for PostgreSQL Flexible Server and private endpoints.

- **variables.tf**:  
  Declares all the input variables required by the module.

- **outputs.tf**:  
  Defines outputs for integration into downstream configurations.

- **provider.tf**:  
  Configures AzureRM provider and required aliases for multi-scope deployments.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "pgsql" {
  source = "../../modules/databases/postgres/flexible"
  name   = format("psql-%s-%s-%03d", var.platform, var.env, 1)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-POSTGRESQL"
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

| Name          | Description                                    |
|---------------|------------------------------------------------|
| `credentials` | Admin username and password for the server.    |
| `id`          | ID of the Azure PostgreSQL Flexible Server.    |
| `name`        | Name of the Azure PostgreSQL Flexible Server.  |

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
