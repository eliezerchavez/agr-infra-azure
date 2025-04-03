<a name="readme-top"></a>

# Terraform Platform: Azure Open Platform

- [Terraform Platform: Azure Open Platform](#terraform-platform-azure-open-platform)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Provisioned Resources Overview](#provisioned-resources-overview)
  - [Input Variables Overview](#input-variables-overview)
  - [Platform Components](#platform-components)
  - [Usage](#usage)
  - [Contributing](#contributing)
    - [Accepted Conventions](#accepted-conventions)
  - [Credits](#credits)

---

## Description

The Azure Open Platform provides a foundational infrastructure solution designed for cloud-native applications and services. It includes comprehensive resources for hosting containerized workloads, databases, caching, secure storage, monitoring, and networking, enabling rapid, scalable, and secure deployments.

This platform leverages Terraform to provision resources in Azure, adhering to best practices for security, performance, and maintainability. The Open Platform serves as a foundational layer upon which specialized platforms, such as the Azure Artificial Intelligence (AI) Platform, can be built.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Provisioned Resources Overview

The Open Platform provisions the following Azure resources:

- **Resource Groups**  
  Logical organization and governance of resources.

- **Networking Resources**  
  - Virtual Networks (VNets)
  - Subnets with Network Security Groups (NSGs)
  - Route Tables for optimized routing
  - Private DNS Zones for secure endpoint resolution

- **Compute & Containers**  
  - Azure Kubernetes Service (AKS) for orchestrating container workloads.
  - Azure Container Registry (ACR) for managing container images.

- **Database & Caching**  
  - Azure PostgreSQL Flexible Server: managed relational database.
  - Azure Redis Cache: distributed caching for improved performance.

- **Storage & Security**  
  - Azure Storage Accounts (Blob storage, File shares).
  - Azure Key Vault: secure storage of secrets, certificates, and keys.

- **Monitoring & Logging**  
  - Azure Application Insights for application performance monitoring.
  - Azure Log Analytics Workspace for comprehensive logs analytics.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name            | Type     | Required | Default       | Description                                                                                                                                                |
|-----------------|----------|----------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `business_unit` | `string` | No       | `"corporate"` | Specifies the Avangrid business unit for which resources are being provisioned. Valid values are 'corporate', 'networks', or 'renewables'.                 |
| `env`           | `string` | No       | `"dev"`       | Deployment environment of the application, workload, or service. Valid values are 'dev', 'qat', or 'prd'.                                                  |
| `location`      | `string` | No       | `"eastus"`    | The location/region to keep all your network resources. Valid values are 'eastus', or 'westus2'.                                                           |
| `platform`      | `string` | Yes      | n/a           | The name of the platform hosting multiple applications. This value is used to identify the resource group and all associated resources within the platform.|

Further variables and configurations are detailed in the [`variables.tf`](./variables.tf) file.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Platform Components

The Open Platform Terraform configuration includes the following files:

- **`main.tf`**  
  Main Terraform definitions for resource deployment.

- **`variables.tf`**  
  Input variables definitions with descriptions for clarity.

- **`locals.tf`**  
  Contains local Terraform expressions for consistency and maintainability.

- **`data.tf`**  
  External data source lookups and integrations.

- **`outputs.tf`**  
  Outputs critical information about provisioned resources.

- **`provider.tf` & `versions.tf`**  
  Configures Terraform version constraints and AzureRM providers.

- **`vars/dev.tfvars`**  
  Example variable definitions specifically for development environments.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

Deploy the Azure Open Platform infrastructure using the following Terraform commands:

```bash
source util/setenv.sh
terraform -chdir=terraform/platform/open init -backend-config="key=platform/open/<business_unit>/<env>/terraform.tfstate"
terraform -chdir=terraform/platform/open plan -var-file=vars/<env>.tfvars
terraform -chdir=terraform/platform/open apply -var-file=vars/<env>.tfvars -auto-approve
```

Example for a development deployment:

```bash
source util/setenv.sh
terraform -chdir=terraform/platform/open init -backend-config="key=platform/open/corporate/dev/terraform.tfstate"
terraform -chdir=terraform/platform/open plan -var-file=vars/dev.tfvars
terraform -chdir=terraform/platform/open apply -var-file=vars/dev.tfvars -auto-approve
```

Replace `<business_unit>` and `<env>` appropriately based on your configuration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to enhance the platform's functionality or documentation are welcomed. Please open an issue or submit a pull request. Ensure your contributions include relevant testing and adhere to the conventions below.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation, Platform Design & Implementation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
