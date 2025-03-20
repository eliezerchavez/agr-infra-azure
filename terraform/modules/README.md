<a name="readme-top"></a>

# Terraform Modules

- [Terraform Modules](#terraform-modules)
  - [Description](#description)
  - [Available Modules](#available-modules)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This index provides an overview and quick access to all available Terraform modules created to streamline deployments in Azure. Each module is documented comprehensively to facilitate easy integration and consistent cloud infrastructure management.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Available Modules

| Module                                                                  | Description                                                        | 
|-------------------------------------------------------------------------|--------------------------------------------------------------------|
| [Azure Kubernetes Service (AKS)](containers/aks/)                       | Deploys managed Kubernetes clusters on Azure.                      |
| [Azure Container Registry (ACR)](containers/acr/)                       | Provisions Azure Container Registries for Docker image management. |
| [Azure Redis Cache](databases/redis_cache/)                             | Creates highly available Redis Cache instances.                    |
| [Azure Route Table](networking/route_table/)                            | Manages network traffic routing with route tables.                 |
| [Azure Subnet](networking/subnet/)                                      | Deploys subnets with optional delegation and service endpoints.    |
| [Azure Key Vault](security/key_vault/)                                  | Provides secure management of secrets, keys, and certificates.     |
| [Azure Storage Account](storage/storage_account/)                       | Configures Azure storage accounts with containers and file shares. |
| [Azure PostgreSQL Flexible Server](databases/postgres_flexible_server/) | Sets up PostgreSQL databases with flexible scaling options.        |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

Each module folder contains a detailed README with usage examples. Refer to the respective documentation for integration instructions.

Example:

```hcl
module "example_module" {
  source = "../modules/<module_name>"

  # Module-specific variables
}
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
