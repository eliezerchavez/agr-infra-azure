<a name="readme-top"></a>

# Azure Shared Resources

- [Azure Shared Resources](#azure-shared-resources)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Provisioned Resources Overview](#provisioned-resources-overview)
  - [Project Components](#project-components)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

The Azure Shared Resources project provisions common infrastructure components intended for use across all resource groups and applications within an Azure subscription. It ensures consistency, security, and centralized management of critical resources, simplifying deployment processes and reducing redundancy.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Provisioned Resources Overview

The shared resources provisioned by this project include:

- **Resource Groups**: Centralized groups for managing shared resources.
- **Virtual Networks (VNets)**: Establishes a secure networking environment used by all resources.
- **Subnets and Network Security Groups (NSGs)**: Defines secure and controlled network segmentation.
- **Route Tables**: Manages consistent network traffic routing.
- **Azure Key Vault**: Centralized secure storage for managing sensitive information such as secrets and certificates.
- **Azure Storage Accounts**: Common storage services for persistent data storage and retrieval.
- **Azure Container Registry (ACR)**: Shared registry for container image management.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Project Components

This project consists of the following Terraform files:

- **main.tf**:  
  Core resource definitions and orchestration logic for shared infrastructure.

- **variables.tf**:  
  Defines input variables for customizing the deployment of shared resources.

- **locals.tf**:  
  Contains reusable expressions and simplifies resource configuration.

- **data.tf**:  
  Retrieves data from existing Azure resources or external sources.

- **provider.tf**:  
  Configures Terraform providers and sets aliases for multi-region or multi-scope deployments.

- **versions.tf**:  
  Specifies Terraform and provider version constraints.

*(Additional helper files or resources may be included as necessary.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

To deploy the Azure Shared Resources infrastructure, reference the following example:

```hcl
module "shared_resources" {
  source = "../projects/shared_resources"

  resource_group_name = "shared-resources-rg"
  location            = "eastus"

  vnet_address_space  = ["10.0.0.0/16"]
  subnet_configs      = [{ name = "shared-subnet", address_prefixes = ["10.0.1.0/24"] }]
  key_vault_name      = "shared-kv"
  storage_account_name = "sharedstorageacc"
  acr_name            = "sharedacr"

  # Other shared-specific variables
}
```

Refer to `variables.tf` for a detailed list of configurable parameters.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

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

