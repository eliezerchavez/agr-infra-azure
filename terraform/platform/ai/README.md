<a name="readme-top"></a>

# Terraform Platform: Azure Artificial Intelligence (AI) Platform

- [Terraform Platform: Azure Artificial Intelligence (AI) Platform](#terraform-platform-azure-artificial-intelligence-ai-platform)
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

The Azure Artificial Intelligence (AI) Platform is an advanced infrastructure solution specifically designed for artificial intelligence and machine learning workloads. It extends the capabilities of the Azure Open Platform by adding specialized AI resources such as Azure Cognitive Services, Machine Learning Workspaces, and Cognitive Search, providing a comprehensive, secure, and scalable environment optimized for AI-driven applications and analytics.

This platform leverages Terraform for provisioning, following Azure best practices for security, performance, and scalability.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Provisioned Resources Overview

The AI Platform provisions all resources from the **Open Platform**, plus the following specialized AI-focused Azure resources:

**AI-Specific Resources:**
- **Azure Cognitive Services**: OpenAI, Language Services, Document Intelligence, integrated with Private Endpoints.
- **Azure Machine Learning Workspace**: Secure workspace environment for end-to-end machine learning lifecycle management.
- **Azure Cognitive Search**: Managed intelligent search services with secure network integration.

**Inherited Open Platform Resources:**
- Resource Groups
- Virtual Networks (VNets), Subnets, NSGs, Route Tables
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Redis Cache
- Azure PostgreSQL Flexible Server
- Azure Key Vault
- Azure Storage Accounts
- Azure Application Insights
- Azure Log Analytics Workspace

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name            | Type     | Required | Default       | Description                                                                                                                                                |
|-----------------|----------|----------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `business_unit` | `string` | No       | `"corporate"` | Specifies the Avangrid business unit for which resources are being provisioned. Valid values are 'corporate', 'networks', or 'renewables'.                 |
| `env`           | `string` | No       | `"dev"`       | Deployment environment of the application, workload, or service. Valid values are 'dev', 'qat', or 'prd'.                                                  |
| `location`      | `string` | No       | `"eastus"`    | The location/region to keep all your network resources. Valid values are 'eastus', or 'westus2'.                                                           |
| `platform`      | `string` | Yes      | n/a           | The name of the platform hosting multiple applications. This value is used to identify the resource group and all associated resources within the platform.|

Additional specific variables are detailed in the [`variables.tf`](./variables.tf) file.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Platform Components

The AI Platform Terraform configuration consists of these files:

- **`main.tf`**  
  Main resource definitions, including both Open Platform and AI resources.

- **`variables.tf`**  
  Input variables definitions for flexible deployments.

- **`locals.tf`**  
  Local expressions for resource naming and logic simplification.

- **`data.tf`**  
  External data source integrations.

- **`outputs.tf`**  
  Key resource outputs.

- **`provider.tf` & `versions.tf`**  
  Terraform and AzureRM provider configurations and versioning.

- **`vars/dev.tfvars`**  
  Example variables tailored for development.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

Deploy the Azure AI Platform using Terraform commands:

```bash
source util/setenv.sh
terraform -chdir=terraform/platform/ai init -backend-config="key=platform/ai/<business_unit>/<env>/terraform.tfstate"
terraform -chdir=terraform/platform/ai plan -var-file=vars/<env>.tfvars
terraform -chdir=terraform/platform/ai apply -var-file=vars/<env>.tfvars -auto-approve
```

Example deployment for a dev environment:

```bash
source util/setenv.sh
terraform -chdir=terraform/platform/ai init -backend-config="key=platform/ai/corporate/dev/terraform.tfstate"
terraform -chdir=terraform/platform/ai plan -var-file=vars/dev.tfvars
terraform -chdir=terraform/platform/ai apply -var-file=vars/dev.tfvars -auto-approve
```

Replace `<business_unit>` and `<env>` according to your setup.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to improve the platform's functionality or documentation are welcome. Please open an issue or submit a pull request. Ensure updates include relevant testing.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation, Platform Design & Implementation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
