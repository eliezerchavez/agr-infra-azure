<a name="readme-top"></a>

# Terraform Module: Azure Key Vault

- [Terraform Module: Azure Key Vault](#terraform-module-azure-key-vault)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
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

This module provisions an Azure Key Vault, securely managing secrets, keys, and certificates with integration into private networks via private endpoints. It is designed to ensure compliance with security best practices for sensitive data management.

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

| Name  | Type        | Required | Default | Description                    |
|-------|-------------|----------|---------|--------------------------------|
| `name`| `string`    | Yes      | n/a     | Name of the Key Vault.         |
| `pe`  | `object`    | Yes      | n/a     | Private endpoint configuration.|
| `rg`  | `object`    | Yes      | n/a     | Resource group configuration.  |
| `tags`| `map(any)`  | Yes      | n/a     | Tags assigned to resources.    |
| `vnet`| `object`    | Yes      | n/a     | Virtual network configuration. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Required | Default | Description                               |
|-----------|----------|----------|---------|-------------------------------------------|
| `rg.name` | `string` | Yes      | n/a     | Resource group name for private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details used for deployment.

| Attribute  | Type     | Required | Default | Description                 |
|------------|----------|----------|---------|-----------------------------|
| `id`       | `string` | Yes      | n/a     | Resource group ID.          |
| `location` | `string` | Yes      | n/a     | Azure region of the group.  |
| `name`     | `string` | Yes      | n/a     | Name of the resource group. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Virtual Network (`vnet`)

Virtual network details for Key Vault integration.

| Attribute   | Type     | Required | Default | Description                |
|-------------|----------|----------|---------|----------------------------|
| `id`        | `string` | Yes      | n/a     | Virtual Network ID.        |
| `subnet.id` | `string` | Yes      | n/a     | Subnet ID within the VNet. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module is composed of the following files:

- **main.tf**:  
  Contains primary definitions for Azure Key Vault resources and private endpoints.

- **variables.tf**:  
  Declares all input variables required by the module.

- **outputs.tf**:  
  Defines outputs such as Key Vault ID and URI for downstream configurations.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```hcl
module "kv" {
  source = "../../modules/security/kv"

  name = format("kv-%s-%s", var.platform, var.env)

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

| Name   | Description                  |
|--------|------------------------------|
| `id`   | ID of the Azure Key Vault.   |
| `name` | Name of the Azure Key Vault. |

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
