<a name="readme-top"></a>

# Azure Open Platform

- [Azure Open Platform](#azure-open-platform)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Provisioned Resources Overview](#provisioned-resources-overview)
  - [Platform Components](#platform-components)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

The Azure Open Platform provides an extensive infrastructure solution designed to support cloud native, scalable, and secure applications. Leveraging Azure cloud resources, it facilitates rapid deployment and management of diverse workloads, adhering strictly to cloud best practices for performance, security, and scalability.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Provisioned Resources Overview

This platform provisions and manages the following Azure resources:

- **Resource Groups**: Logical containers for grouping resources to streamline management.
- **Networking Resources**: Includes Virtual Networks (VNets), Subnets, Network Security Groups (NSGs), and Route Tables for secure and controlled network traffic.
- **Azure Container Registry (ACR)**: Container registry to store and manage container images securely.
- **Azure Kubernetes Service (AKS)**: Managed Kubernetes clusters for container orchestration and scalable deployment.
- **Azure Redis Cache**: Provides distributed caching services to enhance performance and reduce latency.
- **Azure PostgreSQL Flexible Server**: Managed database services with flexible scaling, high availability, and security features.
- **Azure Key Vault**: Secure management and storage of secrets, keys, and certificates.
- **Azure Storage Account**: Highly durable and scalable storage solutions including Blob storage and File shares.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name            | Type     | Required | Default    | Description                                                                   |
|-----------------|----------|----------|------------|-------------------------------------------------------------------------------|
| `business_unit` | `string` | Yes      | n/a        | Business Unit identifier for resource naming and tagging.                     |
| `env`           | `string` | Yes      | n/a        | Environment identifier (e.g., dev, qa, prod) for resource naming and tagging. |
| `location`      | `string` | No       | `"eastus"` | Azure region for the platform deployment.                                     |
| `net`           | `object` | No       | See below  |                                                                               |
| `platform`      | `string` | No       | `"open"`   | Platform type identifier used in naming resources.                            |

### Network (`net`) Variable Details

| Attribute                | Type          | Required | Default | Description                                                 |
|--------------------------|---------------|----------|---------|-------------------------------------------------------------|
| `snet.address_prefix`    | `string`      | Yes      | n/a     | Address prefix for the subnet within the VNet.              |
| `rt.routes`              | `map(object)` | Yes      | n/a     | Route table entries.                                        |
| `rt.routes.<name>`       | `object`      | Yes      | n/a     | Individual route entry configuration.                       |
| `address_prefix`         | `string`      | Yes      | n/a     | Destination CIDR block for route entry.                     |
| `next_hop_type`          | `string`      | Yes      | n/a     | Next hop type (e.g., VirtualAppliance, Internet).           |
| `next_hop_in_ip_address` | `string`      | No       | n/a     | Next hop IP address (required if type is VirtualAppliance). |

---

## Platform Components

This platform consists of the following Terraform files:

- **main.tf**:  
  Core infrastructure resource definitions and orchestration logic.

- **variables.tf**:  
  Defines all input variables for customizing the platform deployment.

- **locals.tf**:  
  Contains reusable local expressions and simplified logic.

- **data.tf**:  
  Retrieves external data sources such as existing Azure resources.

- **provider.tf**:  
  Configures Terraform providers and defines provider aliases for multi-region and multi-scope deployments.

- **versions.tf**:  
  Specifies compatible Terraform and provider versions.

*(Additional helper files or resources may be included as necessary.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

To deploy the Azure Open Platform, reference this example Terraform module usage snippet:

```bash
source util/setenv.sh
terraform init -chdir=terraform/platform/open -backend-config="key=platform/<platform type>/<business unit>/<env>/terraform.tfstate"
terraform plan -chdir=terraform/platform/open -var-file=vars/<env>.tfvars
terraform apply -chdir=terraform/platform/open -var-file=vars/<env>.tfvars -auto-approve
```

i.e.

```bash
source util/setenv.sh
terraform init -chdir=terraform/platform/open -backend-config="key=platform/open/corporate/dev/terraform.tfstate"
terraform plan -chdir=terraform/platform/open -var-file=vars/dev.tfvars
terraform apply -chdir=terraform/platform/open -var-file=vars/dev.tfvars -auto-approve
```

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
