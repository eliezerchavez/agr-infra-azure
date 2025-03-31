<a name="readme-top"></a>

# Terraform Module: Azure Cognitive Services Account

- [Terraform Module: Azure Cognitive Services Account](#terraform-module-azure-cognitive-services-account)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Cognitive Services account with secure network connectivity via Private Endpoint. It includes the creation of the Azure Cognitive Services Account, User Assigned Identity, and configuration of Private DNS zone integration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                            | Type       | Required | Default           | Description                                              |
|---------------------------------|------------|----------|-------------------|----------------------------------------------------------|
| `name`                          | `string`   | Yes      | n/a               | Name for Azure Cognitive Services account.               |
| `kind`                          | `string`   | No       | `"OpenAI"`        | Cognitive service type.                                  |
| `sku_name`                      | `string`   | No       | `"S0"`            | SKU for Azure Cognitive Services account.                |
| `network_acls`                  | `object`   | No       | See below         | Network access control list configuration.               |
| `public_network_access_enabled` | `bool`     | No       | `false`           | Whether public network access is enabled.                |
| `pe`                            | `object`   | Yes      | n/a               | Resource group details for the Private DNS Zone.         |
| `rg`                            | `object`   | Yes      | n/a               | Resource group details for deployment.                   |
| `vnet`                          | `object`   | Yes      | n/a               | Virtual network details for private endpoint connection. |
| `tags`                          | `map(any)` | Yes      | n/a               | Tags for resource identification and management.         |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Network ACLs (`network_acls`)

Configuration for the network-level access to the Azure Cognitive Account. You can define IP allowlists, subnet rules, and general traffic behavior using this structure.

| Attribute               | Type           | Required | Default           | Description                                                          |
|-------------------------|----------------|----------|-------------------|----------------------------------------------------------------------|
| `bypass`                | `string`       | No       | `"AzureServices"` | Specifies which traffic can bypass the network rules.                |
| `default_action`        | `string`       | No       | `"Deny"`          | The default action for incoming traffic. Options: `Allow` or `Deny`. |
| `ip_rules`              | `list(string)` | No       | `[]`              | List of allowed public IP addresses or CIDRs.                        |
| `virtual_network_rules` | `list(string)` | No       | `[]`              | List of allowed subnet resource IDs for virtual network access.      |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Description                                                     |
|-----------|----------|-----------------------------------------------------------------|
| `rg.name` | `string` | The name of the resource group that hosts the private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details for deploying the cluster.

| Attribute  | Type     | Description                                                                 |
|------------|----------|-----------------------------------------------------------------------------|
| `id`       | `string` | The resource group identifier (e.g., `/subscriptions/.../myResourceGroup`). |
| `location` | `string` | The Azure region of the resource group (e.g., `eastus`).                    |
| `name`     | `string` | The name of the resource group.                                             |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Virtual Network (`vnet`)

Virtual network integration details.

| Attribute       | Type     | Description                                                 |
|-----------------|----------|-------------------------------------------------------------|
| `id`            | `string` | The identifier of the Virtual Network.                      |
| `subnet.id`     | `string` | The identifier of the Subnet within the Virtual Network.    |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module consists of:

- **main.tf**:
  Provisions the:
  - Azure Cognitive Account
  - Azure User Assigned Identity
  - Private Endpoint with DNS Zone integration

- **variables.tf**:  
  Defines input variables and default values.

- **outputs.tf**:  
  Provides outputs for easy integration.

- **provider.tf**:  
  Specifies required AzureRM providers with aliases.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "oai" {
  source              = "../../modules/cognitive"
  name                = "openai-prod"

  rg = {
    id       = "/subscriptions/.../resourceGroups/rg-openai"
    location = "eastus"
    name     = "rg-openai"
  }

  pe = {
    rg = { name = "rg-private-dns" }
  }

  vnet = {
    id = "/subscriptions/.../vnet/vnet-prod"
    subnet = {
      id = "/subscriptions/.../subnets/subnet-openai"
    }
    route_table = {
      id = "/subscriptions/.../routeTables/rt-prod"
    }
  }

  tags = {
    environment = "production"
    project     = "openai"
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                                   |
|--------|-----------------------------------------------|
| `id`   | ID of the Azure Cognitive Services account.   |
| `name` | Name of the Azure Cognitive Services account. |

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

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
