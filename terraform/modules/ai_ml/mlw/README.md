<a name="readme-top"></a>

# Terraform Module: Azure Machine Learning Workspace

- [Terraform Module: Azure Machine Learning Workspace](#terraform-module-azure-machine-learning-workspace)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
    - [Network ACLs (`network_acls`)](#network-acls-network_acls)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an **Azure Machine Learning Workspace** with secure networking, user-assigned identity support, and all necessary role assignments. It integrates with Application Insights, Key Vault, Storage Account, ACR (optional), and Private DNS zones for full platform readiness.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                            | Type       | Required | Default                        | Description                                                              |
|---------------------------------|------------|----------|--------------------------------|--------------------------------------------------------------------------|
| `name`                          | `string`   | Yes      | n/a                            | Name of the Azure Machine Learning Workspace.                            |
| `rg`                            | `object`   | Yes      | n/a                            | Full resource group object including `id`, `name`, and `location`.       |
| `identity_ids`                  | `list`     | No       | `[]`                           | Optional list of User Assigned Identity IDs. Creates a new one if empty. |
| `kv`                            | `object`   | Yes      | n/a                            | Key Vault used by the workspace.                                         |
| `vnet`                          | `object`   | Yes      | n/a                            | Virtual network and subnet used for the Private Endpoint.                |
| `private_dns_rg`                | `string`   | No       | `"RG-COMMON-NETWORKING-AZDNS"` | Resource group containing the private DNS zones.                         |
| `public_network_access_enabled` | `bool`     | No       | `false`                        | Whether public network access is enabled.                                |
| `network_acls`                  | `object`   | No       | See below                      | Configuration for default actions, IP allow lists, and bypass settings.  |
| `kind`                          | `string`   | No       | `"Default"`                    | Kind of Azure ML Workspace.                                              |
| `sku_name`                      | `string`   | No       | `"Basic"`                      | SKU tier (e.g., `Basic`, `Enterprise`).                                  |
| `appi`                          | `object`   | Yes      | n/a                            | Application Insights ID.                                                 |
| `cr`                            | `object`   | No       | `{}`                           | Optional ACR to associate for training/inference workloads.              |
| `storage`                       | `object`   | Yes      | n/a                            | Storage Account ID to associate with the workspace.                      |
| `tags`                          | `map(any)` | Yes      | n/a                            | Tags for resource classification and governance.                         |

### Resource Group (`rg`)

Full Azure Resource Group object. This variable is passed as-is from a data source or parent module output.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

### Virtual Network (`vnet`)

Object representing the Virtual Network and the subnet to be used for Private Endpoint.

| Attribute     | Type     | Description                                                  |
|---------------|----------|--------------------------------------------------------------|
| `subnet.id`   | `string` | ID of the subnet used for the Machine Learning Workspace PE. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module includes:

- **`main.tf`**  
  Provisions the ML Workspace with identity and integrations.

- **`iam.tf`**  
  Grants required role assignments to the identities for Key Vault, Storage, ACR, and App Insights.

- **`pe.tf`**  
  Creates Private Endpoint and binds to Private DNS Zone.

- **`variables.tf`**  
  Structured and grouped inputs following Logical Grouping guidelines.

- **`outputs.tf`**  
  Outputs the workspace name and ID.

- **`provider.tf`**  
  Declares the providers and aliases used.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "mlw" {
  source = "../../modules/ai_ml/mlw"

  name = "mlw-gaip-dev"

  rg = {
    id       = "/subscriptions/xxxx/resourceGroups/rg-gaip-dev"
    name     = "rg-gaip-dev"
    location = "eastus"
  }

  vnet = {
    subnet = {
      id = "/subscriptions/xxxx/subnets/ml-subnet"
    }
  }

  appi = {
    id = "/subscriptions/xxxx/resourceGroups/rg-gaip-dev/providers/microsoft.insights/components/appi-gaip"
  }

  kv = {
    id = "/subscriptions/xxxx/resourceGroups/rg-gaip-dev/providers/Microsoft.KeyVault/vaults/kv-gaip"
  }

  cr = {
    id = "/subscriptions/xxxx/resourceGroups/rg-gaip-dev/providers/Microsoft.ContainerRegistry/registries/acrgaip"
  }

  storage = {
    id = "/subscriptions/xxxx/resourceGroups/rg-gaip-dev/providers/Microsoft.Storage/storageAccounts/sagaip"
  }

  private_dns_rg = "RG-COMMON-NETWORKING-AZDNS"

  identity_ids = []

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

| Name   | Description                                             |
|--------|---------------------------------------------------------|
| `id`   | ID of the Azure Machine Learning Workspace.             |
| `name` | Name of the Azure Machine Learning Workspace resource.  |

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
| 🔐 Security / Identity   | `identity_ids`, `key_vault_id`, `application_insights_id`                |
| 🌐 Networking            | `vnet`, `private_endpoint`, `public_network_access_enabled`              |
| ⚙️ Settings / Config     | `sku_name`, `kind`, `container_registry_id`                              |
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

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") – _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
