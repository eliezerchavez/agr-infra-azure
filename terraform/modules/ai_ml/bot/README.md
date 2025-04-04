<a name="readme-top"></a>

# Terraform Module: Azure Bot Service

- [Terraform Module: Azure Bot Service](#terraform-module-azure-bot-service)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Application (`application`)](#application-application)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Bot Service using `azurerm_bot_channels_registration`, and enables secure networking with Private Endpoints and Private DNS zones for the required `directline` and `token` subresources.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                            | Type       | Required | Default                                | Description                                                                   |
|---------------------------------|------------|----------|----------------------------------------|-------------------------------------------------------------------------------|
| `application`                   | `object`   | Yes      | n/a                                    | Microsoft App object with the ID to register the bot.                         |
| `name`                          | `string`   | Yes      | n/a                                    | Globally unique name for the Bot resource.                                    |
| `private_dns_rg`                | `string`   | No       | `"RG-COMMON-NETWORKING-AZDNS"`         | Resource group where the private DNS zones are located.                       |
| `public_network_access_enabled` | `bool`     | No       | `false`                                | Whether public network access is enabled.                                     |
| `rg`                            | `any`      | Yes      | n/a                                    | Full Azure Resource Group object where all module resources will be deployed. |
| `sku`                           | `string`   | No       | `"F0"`                                 | SKU tier for the Bot resource.                                                |
| `tags`                          | `map(any)` | Yes      | n/a                                    | Tags to apply to all resources.                                               |
| `vnet`                          | `object`   | Yes      | n/a                                    | Virtual Network input with the subnet to use for Private Endpoints.           |

### Application (`application`)

| Attribute | Type     | Description                            |
|-----------|----------|----------------------------------------|
| `id`      | `string` | Microsoft App ID to link to the Bot.   |

### Resource Group (`rg`)

Full Azure Resource Group object. This variable is passed as-is from a data source or parent module output.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

### Virtual Network (`vnet`)

Object representing the Virtual Network and the subnet to be used for Private Endpoint.

| Attribute     | Type     | Description                                            |
|---------------|----------|--------------------------------------------------------|
| `subnet.id`   | `string` | ID of the subnet used for the Bot’s Private Endpoints. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module includes:

- **`main.tf`**  
  Provisions the Azure Bot Channels Registration resource.

- **`pe.tf`**  
  Creates Private Endpoints for `directline` and `token`, and connects them to their respective Private DNS zones.

- **`variables.tf`**  
  Defines and documents input variables.

- **`outputs.tf`**  
  Exposes the main resource outputs (`id`, `name`).

- **`provider.tf`**  
  Declares required AzureRM providers and aliases for `azurerm.app` and `azurerm.hub`.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "bot" {
  source = "../../modules/ai_ml/bot"

  name = "bot-gaip-dev"

  application = {
    id = "00000000-0000-0000-0000-000000000000"
  }

  rg = data.azurerm_resource_group.rg

  vnet = {
    subnet = {
      id = "/subscriptions/xxxx/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/bot-subnet"
    }
  }

  private_dns_rg = "RG-COMMON-NETWORKING-AZDNS"

  public_network_access_enabled = false

  tags = {
    environment = "dev"
    project     = "bot-gaip"
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                                     |
|--------|-------------------------------------------------|
| `id`   | ID of the Azure Bot Channels Registration.      |
| `name` | Name of the Azure Bot resource.                 |

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

## Module Development Guidelines

### Logical Grouping Order

| Group                    | Example Fields                                                           |
|--------------------------|--------------------------------------------------------------------------|
| 🔷 Identity / Basic Info | `name`, `location`, `resource_group_name`                                |
| 🔐 Security / Identity   | `identity`, `key_vault_id`, `application_insights_id`, etc.              |
| 🌐 Networking            | `vnet`, `subnet_id`, `private_endpoint`, `public_network_access_enabled` |
| ⚙️ Settings / Config     | `sku`, `app_id`, `custom_subdomain_name`, `settings`, etc.               |
| 🏷️ Tags                  | `tags`                                                                   |
| 🔁 Lifecycle             | `lifecycle`, `depends_on`                                                |

> This grouping helps maintain readability and aligns with Azure best practices for resource declarations.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

### Variable Declaration Strategy

Variables are intentionally grouped by purpose, not listed alphabetically. This logical ordering improves readability and aligns with the resource layout in the Terraform code itself.

| Group                    | Purpose                                                               |
|--------------------------|-----------------------------------------------------------------------|
| 🔷 Identity / Basic Info | Basic resource identifiers and scope (e.g., `name`, `rg`)             |
| 🔐 Security / Identity   | Identity configuration, Microsoft App IDs, Key Vault, etc.            |
| 🌐 Networking            | Network-related inputs like `vnet`, `subnet`, Private DNS, endpoints  |
| ⚙️ Settings / Config     | Configuration options like SKU, versioning, and app-specific settings |
| 🏷️ Tags                  | Tags used for governance, cost control, or discovery                  |

This grouping also matches the field order used in resource blocks, helping teams onboard quickly and reducing cognitive load.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
