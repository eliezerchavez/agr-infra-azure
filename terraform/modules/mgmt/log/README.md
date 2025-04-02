<a name="readme-top"></a>

# Terraform Module: Azure Log Analytics Workspace

- [Terraform Module: Azure Log Analytics Workspace](#terraform-module-azure-log-analytics-workspace)  
  - [Description](#description)  
  - [Requirements](#requirements)  
  - [Input Variables Overview](#input-variables-overview)  
    - [Resource Group (`rg`)](#resource-group-rg)  
  - [Module Components](#module-components)  
  - [Usage](#usage)  
  - [Outputs](#outputs)  
  - [Contributing](#contributing)  
  - [Credits](#credits)  
  - [Module Development Guidelines](#module-development-guidelines)  

---

## Description

This module provisions an **Azure Log Analytics Workspace** using the `azurerm_log_analytics_workspace` resource. It allows configuring SKU, retention policies, and connects to the desired resource group. The workspace supports standard tagging and is suitable for logging, telemetry, and integration with services like Azure Monitor, Application Insights, and Sentinel.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.  
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name                | Type       | Required | Default       | Description                                                 |
|---------------------|------------|----------|---------------|-------------------------------------------------------------|
| `name`              | `string`   | Yes      | n/a           | Name of the Log Analytics Workspace. Must be unique.        |
| `rg`                | `any`      | Yes      | n/a           | Resource Group object where the workspace will be deployed. |
| `sku`               | `string`   | No       | `"PerGB2018"` | SKU of the Log Analytics Workspace.                         |
| `retention_in_days` | `number`   | No       | `30`          | Number of days to retain data.                              |
| `tags`              | `map(any)` | Yes      | n/a           | Tags to apply to the workspace.                             |

### Resource Group (`rg`)

The full Azure Resource Group object. This variable is passed from a data source or parent module.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module includes:

- **`main.tf`**  
  Declares the `azurerm_log_analytics_workspace` resource.

- **`variables.tf`**  
  Defines input variables including workspace name, SKU, retention, and tags.

- **`outputs.tf`**  
  Exposes relevant outputs (`id`, `name`, `workspace_id`) for downstream usage.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "log" {
  source = "../../modules/monitoring/log"

  name = "log-gaip-dev"

  rg = {
    id       = "/subscriptions/xxxx/resourceGroups/rg-monitor"
    name     = "rg-monitor"
    location = "eastus"
  }

  sku                = "PerGB2018"
  retention_in_days  = 30

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

| Name           | Description                                     |
|----------------|-------------------------------------------------|
| `id`           | ID of the Log Analytics Workspace.              |
| `name`         | Name of the Log Analytics Workspace.            |

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
| 🔐 Security / Identity   | `identity`, `key_vault_id`, etc.                                         |
| 🌐 Networking            | `vnet`, `subnet_id`, `private_endpoint`, `public_network_access_enabled` |
| ⚙️ Settings / Config     | `sku`, `retention_in_days`, etc.                                         |
| 🏷️ Tags                  | `tags`                                                                   |
| 🔁 Lifecycle             | `lifecycle`, `depends_on`                                                |

> This grouping helps maintain readability and aligns with Azure best practices for resource declarations.

---

### Variable Declaration Strategy

Variables are intentionally grouped by purpose, not listed alphabetically. This logical ordering improves readability and aligns with the resource layout in the Terraform code itself.

| Group                    | Purpose                                                               |
|--------------------------|-----------------------------------------------------------------------|
| 🔷 Identity / Basic Info | Basic resource identifiers and scope (e.g., `name`, `rg`)             |
| 🔐 Security / Identity   | Identity configuration, Key Vault, App Insights, etc.                 |
| 🌐 Networking            | Network-related inputs like `vnet`, `subnet`, Private DNS, endpoints  |
| ⚙️ Settings / Config     | Configuration options like SKU, retention, and data ingestion         |
| 🏷️ Tags                  | Tags used for governance, cost control, or discovery                  |

This grouping also matches the field order used in resource blocks, helping teams onboard quickly and reducing cognitive load.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
