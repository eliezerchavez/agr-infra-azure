<a name="readme-top"></a>

# Terraform Modules

- [Terraform Modules](#terraform-modules)
  - [Description](#description)
  - [Available Modules](#available-modules)
  - [Usage](#usage)
  - [Contributing](#contributing)
    - [Accepted Conventions](#accepted-conventions)
  - [Credits](#credits)

---

## Description

This index provides an overview and quick access to all available Terraform modules designed to streamline Azure cloud deployments. Each module is comprehensively documented, ensuring ease of integration, consistent infrastructure management, and adherence to best practices.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Available Modules

| Module                                                                  | Description                                                                                                                                         |
|-------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| **AI + Machine Learning**                                               |                                                                                                                                                     |
| [Azure Bot Service](ai_ml/bot/)                                         | Provisions Azure Bot Channels Registration with secure private endpoints, identity management, and integrated DNS zones.                            |
| [Azure Cognitive Services](ai_ml/cognitive/)                            | Deploys Azure Cognitive Services (e.g., OpenAI, Document Intelligence, Language Services) with configurable SKU, private networking, and identity.  |
| [Azure Machine Learning Workspace](ai_ml/mlw/)                          | Provisions Azure Machine Learning Workspace with secure networking, private endpoints, identity management, and integrated resources.               |
| [Azure Cognitive Search](ai_ml/search/)                                 | Deploys Azure Cognitive Search services, securely integrated via private networking and supporting managed identities.                              |
| **Containers**                                                          |                                                                                                                                                     |
| [Azure Kubernetes Service (AKS)](containers/aks/)                       | Provisions and manages fully integrated, secure Azure Kubernetes clusters (AKS) with customizable node pools and networking options.                |
| [Azure Container Registry (ACR)](containers/acr/)                       | Deploys Azure Container Registries for efficient Docker image storage, management, and secure access with managed identities.                       |
| **Databases**                                                           |                                                                                                                                                     |
| [Azure PostgreSQL Flexible Server](databases/postgres_flexible_server/) | Sets up managed PostgreSQL Flexible Servers, offering customizable compute, storage, backups, high availability, and secure networking.             |
| [Azure Redis Cache](databases/redis_cache/)                             | Creates highly available and scalable Azure Redis Cache instances with private endpoint integration and advanced monitoring support.                |
| **Management and Governance**                                           |                                                                                                                                                     |
| [Azure Application Insights](mgmt/appi/)                                | Deploys Application Insights resources to monitor and analyze application performance, including private networking and identity support.           |
| [Azure Log Analytics Workspace](networking/log/)                        | Provisions Azure Log Analytics Workspaces, enabling centralized logging, analytics, secure ingestion endpoints, and integration with Azure Monitor. |
| **Networking**                                                          |                                                                                                                                                     |
| [Azure Route Table](networking/route_table/)                            | Configures Azure Route Tables for advanced network traffic routing, management, and secure subnet associations.                                     |
| [Azure Subnet](networking/subnet/)                                      | Deploys and configures Azure Subnets, supporting delegation, service endpoints, and network security groups.                                        |
| **Security**                                                            |                                                                                                                                                     |
| [Azure Key Vault](security/key_vault/)                                  | Provides secure management of secrets, keys, and certificates, with support for managed identities and private endpoint configurations.             |
| **Storage**                                                             |                                                                                                                                                     |
| [Azure Storage Account](storage/storage_account/)                       | Creates Azure Storage Accounts with optimized configurations, containers, file shares, private endpoints, and secure access management.             |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

Each module folder contains a detailed README file with usage examples and specific input variable guidance. Refer to the respective module documentation for precise integration instructions.

**Example usage:**

```hcl
module "example_module" {
  source = "../modules/<category>/<module_name>"

  # Module-specific variables here
}
```

Replace `<category>` and `<module_name>` with the appropriate module path from the list above.

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
