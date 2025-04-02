<a name="readme-top"></a>

# Terraform Module: Azure Cognitive Services

- [Terraform Module: Azure Cognitive Services](#terraform-module-azure-cognitive-services)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Module Development Guidelines](#module-development-guidelines)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Cognitive Account (`azurerm_cognitive_account`) to support AI capabilities such as OpenAI, Form Recognizer (Document Intelligence), and Text Analytics (Language). It handles identity, private networking via Private Endpoints, and DNS zone integration. You can provide your own User Assigned Identity or let the module create one.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                            | Type           | Required | Default                          | Description                                                                        |
|---------------------------------|----------------|----------|----------------------------------|------------------------------------------------------------------------------------|
| `identity_ids`                  | `list(string)` | No       | `[]`                             | List of User Assigned Identity IDs. A new identity will be created if empty.       |
| `kind`                          | `string`       | Yes      | n/a                              | Type of the cognitive service (e.g., `OpenAI`, `FormRecognizer`, `TextAnalytics`). |
| `name`                          | `string`       | Yes      | n/a                              | Name of the Azure Cognitive Account.                                               |
| `network_acls`                  | `object`       | No       | See below                        | Network access control rules.                                                      |
| `private_dns_rg`                | `string`       | No       | `"RG-COMMON-NETWORKING-AZDNS"`   | Resource group where the private DNS zones are located.                            |
| `public_network_access_enabled` | `bool`         | No       | `true`                           | Whether public network access is enabled.                                          |
| `rg`                            | `any`          | Yes      | n/a                              | Full Azure Resource Group object where all module resources will be deployed.      |
| `sku_name`                      | `string`       | No       | `"S0"`                           | SKU tier for the Cognitive Service.                                                |
| `tags`                          | `map(any)`     | Yes      | n/a                              | Tags to apply to all resources.                                                    |
| `vnet`                          | `object`       | Yes      | n/a                              | Virtual Network input with the subnet to use for Private Endpoints.                |

### Network ACLs (`network_acls`)

Optional firewall rules for IP and network restrictions.

| Attribute        | Type           | Default   | Description                                               |
|------------------|----------------|-----------|-----------------------------------------------------------|
| `bypass`         | `string`       | n/a       | Services that can bypass the network rules. *(Optional)*  |
| `default_action` | `string`       | `"Deny"`  | Default action for traffic not matched by rules.          |
| `ip_rules`       | `list(string)` | `[]`      | List of allowed public IP ranges or addresses.            |

### Resource Group (`rg`)

Full Azure Resource Group object. This variable is passed as-is from a data source or parent module output.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

### Virtual Network (`vnet`)

Object representing the Virtual Network and the subnet to be used for Private Endpoint.

| Attribute     | Type     | Description                                                  |
|---------------|----------|--------------------------------------------------------------|
| `subnet.id`   | `string` | ID of the subnet used for the Cognitive Service PE.          |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module includes:

- **`main.tf`**  
  Provisions the Azure Cognitive Account and optionally a User Assigned Identity.

- **`pe.tf`**  
  Creates the Private Endpoint for the cognitive resource and connects it to the appropriate Private DNS zone.

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
module "cognitive" {
  source = "../../modules/ai_ml/cognitive"

  name = "oai-gaip-dev"
  kind = "OpenAI"

  identity_ids = []

  rg = data.azurerm_resource_group.rg

  vnet = {
    subnet = {
      id = "/subscriptions/xxxx/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/oai-subnet"
    }
  }

  private_dns_rg = "RG-COMMON-NETWORKING-AZDNS"

  public_network_access_enabled = false

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

| Name   | Description                                         |
|--------|-----------------------------------------------------|
| `id`   | ID of the Azure Cognitive Service resource.         |
| `name` | Name of the Azure Cognitive Service resource.       |

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
| ⚙️ Settings / Config     | `sku`, `kind`, `custom_subdomain_name`, `settings`, etc.                 |
| 🏷️ Tags                  | `tags`                                                                   |
| 🔁 Lifecycle             | `lifecycle`, `depends_on`                                                |

> This grouping helps maintain readability and aligns with Azure best practices for resource declarations.

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

This grouping also matches the field order used in resource blocks, helping teams onboard quickly and reduce cognitive load.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
