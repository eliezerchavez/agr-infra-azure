<a name="readme-top"></a>

# Terraform Module: Azure Cognitive Search

- [Terraform Module: Azure Cognitive Search](#terraform-module-azure-cognitive-search)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Module Development Guidelines](#module-development-guidelines)
    - [Logical Grouping Order](#logical-grouping-order)
    - [Variable Declaration Strategy](#variable-declaration-strategy)
  - [Credits](#credits)

---

## Description

This module provisions an **Azure Cognitive Search** service (`azurerm_search_service`) with private networking support via Private Endpoint. It optionally supports assigning a User-Assigned Managed Identity (UAMI) and configures secure access through private DNS zone integration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                            | Type           | Required | Default                        | Description                                                                |
|---------------------------------|----------------|----------|--------------------------------|----------------------------------------------------------------------------|
| `name`                          | `string`       | Yes      | n/a                            | Name of the Azure Cognitive Search service. Must be globally unique.       |
| `rg`                            | `any`          | Yes      | n/a                            | Resource group object where the service will be deployed.                  |
| `sku`                           | `string`       | No       | `"standard"`                   | SKU tier for the search service.                                           |
| `partition_count`               | `number`       | No       | `1`                            | Number of partitions for scaling the service.                              |
| `replica_count`                 | `number`       | No       | `0`                            | Number of replicas for high availability and performance.                  |
| `identity_ids`                  | `list(string)` | No       | `[]`                           | List of User-Assigned Managed Identity IDs. If empty, one will be created. |
| `tags`                          | `map(any)`     | Yes      | n/a                            | Tags to apply to all resources.                                            |
| `private_dns_rg`                | `string`       | No       | `"RG-COMMON-NETWORKING-AZDNS"` | Resource group where the private DNS zone exists.                          |
| `public_network_access_enabled` | `bool`         | No       | `false`                        | Whether the service allows public network access.                          |
| `vnet`                          | `object`       | Yes      | n/a                            | See [Virtual Network](#virtual-network-vnet).                              |

### Resource Group (`rg`)

Full Azure Resource Group object. This variable is passed as-is from a data source or parent module output.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

### Virtual Network (`vnet`)

Object representing the Virtual Network and the subnet to be used for Private Endpoint.

| Attribute     | Type     | Description                                                    |
|---------------|----------|----------------------------------------------------------------|
| `subnet.id`   | `string` | ID of the subnet used for the Search Service Private Endpoint. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module includes:

- **`main.tf`**  
  Provisions the Azure Cognitive Search service and User Assigned Identity.

- **`pe.tf`**  
  Configures a Private Endpoint and DNS zone group.

- **`variables.tf`**  
  Declares all input variables, logically grouped.

- **`outputs.tf`**  
  Exposes useful outputs (`id`, `name`).

- **`provider.tf`**  
  Declares required AzureRM providers and configuration aliases.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "search" {
  source = "../../modules/ai_ml/search"

  name = "search-gaip-dev"

  rg = data.azurerm_resource_group.rg

  vnet = {
    subnet = {
      id = "/subscriptions/xxxx/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/search-subnet"
    }
  }

  sku = "standard"

  tags = {
    environment = "dev"
    project     = "gaip"
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                                      |
|--------|--------------------------------------------------|
| `id`   | ID of the Azure Cognitive Search service.        |
| `name` | Name of the Azure Cognitive Search service.      |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to enhance the module’s functionality or documentation are welcome. Please open an issue or submit a pull request with your suggestions. Remember to update tests as appropriate.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Development Guidelines

### Logical Grouping Order

| Group                    | Example Fields                                                           |
|--------------------------|--------------------------------------------------------------------------|
| 🔷 Identity / Basic Info | `name`, `location`, `resource_group_name`                                |
| 🔐 Security / Identity   | `identity`, `key_vault_id`, `application_insights_id`, etc.              |
| 🌐 Networking            | `vnet`, `subnet_id`, `private_endpoint`, `public_network_access_enabled` |
| ⚙️ Settings / Config     | `sku`, `partition_count`, `replica_count`, etc.                           |
| 🏷️ Tags                  | `tags`                                                                   |
| 🔁 Lifecycle             | `lifecycle`, `depends_on`                                                |

> This grouping helps maintain readability and aligns with Azure best practices for resource declarations.

### Variable Declaration Strategy

Variables are intentionally grouped by purpose, not listed alphabetically. This logical ordering improves readability and aligns with the resource layout in the Terraform code itself.

| Group                    | Purpose                                                               |
|--------------------------|-----------------------------------------------------------------------|
| 🔷 Identity / Basic Info | Basic resource identifiers and scope (e.g., `name`, `rg`)             |
| 🔐 Security / Identity   | Identity configuration or app-specific security config                |
| 🌐 Networking            | Network-related inputs like `vnet`, Private DNS, endpoints            |
| ⚙️ Settings / Config     | Configuration options like SKU, scaling, and features                 |
| 🏷️ Tags                  | Tags used for governance, cost control, or discovery                  |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
