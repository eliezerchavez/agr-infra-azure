<a name="readme-top"></a>

# Terraform Module: Azure Container Registry (ACR)

- [Terraform Module: Azure Container Registry (ACR)](#terraform-module-azure-container-registry-acr)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Geo Replications (`georeplications`)](#geo-replications-georeplications)
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

This module provisions an Azure Container Registry (ACR) with advanced options including geographic replications, SKU management, administrative access control, network security through private endpoints, and virtual network integration. It is suitable for production environments requiring enhanced security and redundancy.

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

| Name                            | Type           | Required | Default   | Description                               |
|---------------------------------|----------------|----------|-----------|-------------------------------------------|
| `admin_enabled`                 | `bool`         | No       | `true`    | Enable admin user for ACR.                |
| `georeplications`               | `list(object)` | No       | See below | Geo-replication configuration.            |
| `name`                          | `string`       | Yes      | n/a       | Name for the Container Registry.          |
| `pe`                            | `object`       | Yes      | n/a       | Private endpoint configuration.           |
| `public_network_access_enabled` | `bool`         | No       | `false`   | Allow public access to ACR.               |
| `rg`                            | `object`       | Yes      | n/a       | Resource Group configuration.             |
| `sku`                           | `string`       | No       | `Premium` | SKU tier for Container Registry.          |
| `tags`                          | `map(any)`     | Yes      | n/a       | Tags assigned to resources.               |
| `vnet`                          | `object`       | Yes      | n/a       | Virtual network and subnet configuration. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Geo Replications (`georeplications`)

Configure geographic replication for enhanced redundancy.

| Attribute                   | Type     | Required | Default     | Description                   |
|-----------------------------|----------|----------|-------------|-------------------------------|
| `location`                  | `string` | Yes      | `"westus2"` | Azure region for replication. |
| `regional_endpoint_enabled` | `bool`   | Yes      | `false`     | Enable regional endpoint.     |
| `zone_redundancy_enabled`   | `bool`   | Yes      | `true`      | Enable zone redundancy.       |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Required | Default | Description                               |
|-----------|----------|----------|---------|-------------------------------------------|
| `rg.name` | `string` | Yes      | n/a     | Resource group name for private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details for deploying the registry.

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
  Contains the primary resource definitions for the Container Registry, including geo-replications and associated private endpoints.

- **variables.tf**:  
  Declares all the input variables required by the module (as detailed above).

- **outputs.tf**:  
  Defines the outputs for the module, such as registry ID and name, for use in downstream configurations.

- **provider.tf**:  
  Configures the AzureRM provider and any necessary provider aliases for multi-scope deployments.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "acr" {
  source = "../modules/containers/acr"

  name = format("cr%s%s%03d", var.business_unit, var.env, 1)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-IT_TOOLS"
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

| Name   | Description                                     |
|--------|-------------------------------------------------|
| `id`   | The ID of the Azure Container Registry.         |
| `name` | The name of the Azure Container Registry.       |

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
