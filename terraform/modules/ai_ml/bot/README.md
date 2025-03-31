<a name="readme-top"></a>

# Terraform Module: Azure Bot Service

- [Terraform Module: Azure Bot Service](#terraform-module-azure-bot-service)
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

This module provisions an Azure Bot Service with secure connectivity using Private Endpoint. It supports private DNS zone integration and uses a configurable SKU.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name     | Type       | Required | Default | Description                                                    |
|----------|------------|----------|---------|----------------------------------------------------------------|
| `name`   | `string`   | Yes      | n/a     | Name of the Azure Bot Service registration.                    |
| `pe`     | `object`   | Yes      | n/a     | Resource group for Private DNS zone association.               |
| `rg`     | `object`   | Yes      | n/a     | Resource Group where resources are deployed.                   |
| `sku`    | `string`   | No       | `"F0"` | SKU tier for the Bot Service.                                   |
| `tags`   | `map(any)` | Yes      | n/a     | Tags for resource identification and management.               |
| `vnet`   | `object`   | Yes      | n/a     | Virtual network configuration for Private Endpoint.            |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

| Attribute   | Type     | Description                                                  |
|-------------|----------|--------------------------------------------------------------|
| `rg.name`   | `string` | Name of the resource group hosting the Private DNS zone.     |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

| Attribute  | Type     | Description                                                   |
|------------|----------|---------------------------------------------------------------|
| `id`       | `string` | Resource Group ID (e.g., `/subscriptions/.../resourceGroups/`). |
| `location` | `string` | Azure region where resources are deployed.                    |
| `name`     | `string` | Name of the resource group.                                   |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Virtual Network (`vnet`)

| Attribute     | Type     | Description                                                  |
|----------------|----------|--------------------------------------------------------------|
| `id`           | `string` | ID of the Virtual Network.                                   |
| `subnet.id`    | `string` | ID of the subnet to associate with the Private Endpoint.     |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module consists of:

- **main.tf**  
  Provisions the:
  - Azure Bot Service
  - Private Endpoint with DNS Zone integration

- **variables.tf**  
  Defines all input variables and their types/defaults.

- **outputs.tf**  
  Outputs useful information such as the Bot Service ID and name.

- **provider.tf**  
  Specifies required provider configurations and aliases.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "bot" {
  source = "../../modules/ai_ml/bot"
  name   = "bot-service-prod"

  rg = {
    id       = "/subscriptions/xxxx/resourceGroups/rg-bot"
    location = "eastus"
    name     = "rg-bot"
  }

  pe = {
    rg = {
      name = "rg-dns-hub"
    }
  }

  vnet = {
    id = "/subscriptions/xxxx/virtualNetworks/hub-vnet"
    subnet = {
      id = "/subscriptions/xxxx/subnets/bot-subnet"
    }
  }

  tags = {
    environment = "production"
    project     = "azure-bot"
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                           |
|--------|---------------------------------------|
| `id`   | ID of the Azure Bot Service resource. |
| `name` | Name of the Azure Bot Service.        |

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
