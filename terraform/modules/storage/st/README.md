<a name="readme-top"></a>

# Terraform Module: Azure Storage Account

- [Terraform Module: Azure Storage Account](#terraform-module-azure-storage-account)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Account (`account`)](#account-account)
    - [File Shares (`shares`)](#file-shares-shares)
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

This module provisions an Azure Storage Account with customizable blob containers, file shares, and private endpoints. It emphasizes secure storage management, accessibility control, and integration within private virtual networks, suitable for scalable and secure cloud storage deployments.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

_**Note:** Provider aliases (`azurerm.app`, `azurerm.hub`) may be required for multi-scope deployments._

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                | Type           | Required | Default    | Description                         |
|---------------------|----------------|----------|------------|-------------------------------------|
| `name`              | `string`       | Yes      | n/a        | Name of the Storage Account.        |
| `account`           | `object`       | No       | See below  | |
| `containers`        | `list(string)` | No       | `[]`       | List of blob containers to create.  |
| `shares`            | `map(object)`  | No       | `{}`       | File shares configuration.          |
| `subresource_names` | `list(string)` | No       | `["blob"]` | Subresources for private endpoints. |
| `pe`                | `object`       | Yes      | n/a        | Private endpoint configuration.     |
| `rg`                | `object`       | Yes      | n/a        | Resource group configuration.       |
| `tags`              | `map(any)`     | No       | n/a        | Tags assigned to resources.         |
| `vnet`              | `object`       | Yes      | n/a        | Virtual network configuration.      |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Account (`account`)



| Attribute          | Type     | Required | Default       | Description                        |
|--------------------|----------|----------|---------------|------------------------------------|
| `kind`             | `object` | No       | `"StorageV2"` | |
| `replication_type` | `number` | No       | `"ZRS"`       | |
| `tier`             | `number` | No       | `"Standard"`  | |

### File Shares (`shares`)

Configuration for Azure file shares.

| Attribute | Type     | Required | Default | Description                        |
|-----------|----------|----------|---------|------------------------------------|
| `<share>` | `object` | No       | `{}`    | Configuration object per share.    |
| `quota`   | `number` | No       | n/a     | Storage quota in GB for the share. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Required | Default | Description                               |
|-----------|----------|----------|---------|-------------------------------------------|
| `rg.name` | `string` | Yes      | n/a     | Resource group name for private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details for deploying the storage account.

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
  Contains primary definitions for Azure Storage Account and related resources.

- **variables.tf**:  
  Declares all input variables required by the module.

- **outputs.tf**:  
  Defines outputs such as Storage Account ID and resource details for downstream configurations.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "st" {
  source = "../../modules/storage/st"

  name = format("sa%s%s%03d", var.platform, var.env, 1)

  pe = local.pe

  rg = local.rg

  subresource_names = ["blob", "file"]

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-GENERAL"
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

| Name   | Description                        |
|--------|------------------------------------|
| `id`   | ID of the Azure Storage Account.   |
| `name` | Name of the Azure Storage Account. |

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

