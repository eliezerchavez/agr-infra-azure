<a name="readme-top"></a>

# Terraform Module: Azure Application Insights

- [Terraform Module: Azure Application Insights](#terraform-module-azure-application-insights)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Resource Group (`rg`)](#resource-group-rg)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Application Insights instance using `azurerm_application_insights`. It supports resource tagging and SKU customization and can be integrated into observability pipelines such as Azure Monitor or Azure Machine Learning.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name      | Type       | Required | Default  | Description                                                      |
|-----------|------------|----------|----------|------------------------------------------------------------------|
| `name`    | `string`   | Yes      | n/a      | Name for the Application Insights resource.                      |
| `rg`      | `any`      | Yes      | n/a      | The full Azure Resource Group object.                            |
| `sku`     | `string`   | No       | `"Basic"`| SKU tier for Application Insights (e.g., `Basic`, `Standard`).   |
| `tags`    | `map(any)` | Yes      | n/a      | Tags to apply to the resource.                                   |

### Resource Group (`rg`)

The full Azure Resource Group object. This variable is passed from a data source or parent module.

> ℹ️ Expected to include properties like `id`, `name`, and `location`.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module includes:

- **`main.tf`**  
  Provisions the Azure Application Insights resource.

- **`variables.tf`**  
  Declares input variables and default values.

- **`outputs.tf`**  
  Exposes outputs such as `id` and `name` for integration with other modules.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "appi" {
  source = "../../modules/monitoring/appi"

  name = "appi-gaip-dev"

  rg = data.azurerm_resource_group.rg

  sku = "Basic"

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
| `id`   | The ID of the Application Insights resource.     |
| `name` | The name of the Application Insights instance.   |

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
