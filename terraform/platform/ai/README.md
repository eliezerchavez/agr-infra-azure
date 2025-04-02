<a name="readme-top"></a>

# Azure Open Platform

- [Azure Open Platform](#azure-open-platform)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Provisioned Resources Overview](#provisioned-resources-overview)
  - [Input Variables Overview](#input-variables-overview)
    - [Network (`net`) Variable Details](#network-net-variable-details)
  - [Platform Components](#platform-components)
  - [Usage](#usage)
  - [Contributing](#contributing)
    - [Accepted Conventions](#accepted-conventions)
  - [Credits](#credits)

---

## Description

The Azure Open Platform provides an extensive infrastructure solution designed to support cloud-native, scalable, and secure applications. Leveraging Azure resources, it enables rapid deployment, streamlined management, and consistent operations for diverse workloads, strictly adhering to Azure best practices for reliability, performance, security, and scalability.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Provisioned Resources Overview

This platform provisions and manages the following core Azure resources:

- **Resource Groups:**  
  Logical containers for efficient resource organization and management.

- **Networking Resources:**  
  Includes Virtual Networks (VNets), Subnets, Network Security Groups (NSGs), and Route Tables for secure and optimized network traffic management.

- **Azure Container Registry (ACR):**  
  Secure, scalable registry for storing and managing container images.

- **Azure Kubernetes Service (AKS):**  
  Fully managed Kubernetes clusters for scalable container orchestration and application deployment.

- **Azure Redis Cache:**  
  High-performance distributed cache service to improve application responsiveness.

- **Azure PostgreSQL Flexible Server:**  
  Managed PostgreSQL database service offering scalable compute, storage, backups, and built-in high availability.

- **Azure Key Vault:**  
  Secure and compliant storage for secrets, keys, and certificates, with identity-based access controls.

- **Azure Storage Account:**  
  Highly durable, secure, and scalable storage solution supporting Blob storage, File shares, and private endpoint access.

- **Azure Application Insights:**  
  Application performance monitoring service integrated with Azure Monitor for comprehensive diagnostics and analytics.

- **Azure Log Analytics Workspace:**  
  Centralized logging solution for advanced analytics, security monitoring, and operational insights.

- **Azure Cognitive Services:**  
  Provisioning of Azure OpenAI, Document Intelligence (Form Recognizer), and Language Services (Text Analytics) with secure private endpoints.

- **Azure Machine Learning Workspace:**  
  Managed ML workspace environment with secure networking, private endpoints, and integrated identity management.

- **Azure Cognitive Search:**  
  Scalable search service integrated securely with private networks and supporting managed identities.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name            | Type     | Required | Default    | Description                                                                   |
|-----------------|----------|----------|------------|-------------------------------------------------------------------------------|
| `business_unit` | `string` | Yes      | n/a        | Business Unit identifier for resource naming and tagging.                     |
| `env`           | `string` | Yes      | n/a        | Environment identifier (e.g., dev, qa, prod) for resource naming and tagging. |
| `location`      | `string` | No       | `"eastus"` | Azure region for the platform deployment.                                     |
| `net`           | `object` | No       | See below  | Network configuration object for subnet and route table definitions.           |
| `platform`      | `string` | No       | `"open"`   | Platform type identifier used in naming resources.                            |

### Network (`net`) Variable Details

| Attribute                          | Type                   | Required | Default | Description                                                          |
|------------------------------------|------------------------|----------|---------|----------------------------------------------------------------------|
| `snet.address_prefix`              | `string`               | Yes      | n/a     | CIDR address prefix for the subnet within the Virtual Network.       |
| `rt.routes`                        | `map(object)`          | Yes      | n/a     | Map defining custom route table entries.                             |
| `rt.routes.<name>`                 | `object`               | Yes      | n/a     | Individual route table entry configuration object.                   |
| `rt.routes.<name>.address_prefix`  | `string`               | Yes      | n/a     | Destination CIDR block for this route.                               |
| `rt.routes.<name>.next_hop_type`   | `string`               | Yes      | n/a     | Type of next hop (e.g., VirtualAppliance, Internet, VnetLocal).      |
| `rt.routes.<name>.next_hop_in_ip_address` | `string`        | No       | n/a     | Next hop IP address required when using 'VirtualAppliance' type.     |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Platform Components

The platform contains the following Terraform files, logically organized for readability and maintenance:

- **`main.tf`**  
  Central definitions of platform resources and orchestration logic.

- **`variables.tf`**  
  Clearly defined and documented input variables to customize platform deployment.

- **`locals.tf`**  
  Reusable and simplified local expressions to streamline code readability and reuse.

- **`data.tf`**  
  External data sources, existing Azure resources, or configurations.

- **`provider.tf`**  
  AzureRM provider configuration and provider aliases for multi-region or scoped deployments.

- **`versions.tf`**  
  Compatibility constraints specifying Terraform and AzureRM provider versions.

*(Additional support files may be added as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

Deploy the Azure Open Platform using the provided Terraform CLI commands below:

```bash
source util/setenv.sh
terraform init -chdir=terraform/platform/open -backend-config="key=platform/<platform>/<business_unit>/<env>/terraform.tfstate"
terraform plan -chdir=terraform/platform/open -var-file=vars/<env>.tfvars
terraform apply -chdir=terraform/platform/open -var-file=vars/<env>.tfvars -auto-approve
```

Example deployment:

```bash
source util/setenv.sh
terraform init -chdir=terraform/platform/open -backend-config="key=platform/open/corporate/dev/terraform.tfstate"
terraform plan -chdir=terraform/platform/open -var-file=vars/dev.tfvars
terraform apply -chdir=terraform/platform/open -var-file=vars/dev.tfvars -auto-approve
```

Replace placeholders (`<platform>`, `<business_unit>`, `<env>`) with your specific configuration values.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to enhance platform functionality or documentation are welcome. Please open an issue or submit a pull request with your suggestions. Remember to update tests as appropriate.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
