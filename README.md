<a name="readme-top"></a>

# Azure Infrastructure as Code (IaC) Repository

- [Azure Infrastructure as Code (IaC) Repository](#azure-infrastructure-as-code-iac-repository)
  - [Description](#description)
  - [Repository Structure](#repository-structure)
  - [Getting Started](#getting-started)
  - [Modules](#modules)
  - [Platforms](#platforms)
  - [Shared Deployments](#shared-deployments)
  - [Utilities](#utilities)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This repository serves as the central Infrastructure as Code (IaC) repository for managing all Azure deployments within the organization. It provides reusable Terraform modules, platform-specific configurations, shared infrastructure deployments, and utility scripts to streamline the provisioning and management of Azure resources.

The goal of this repository is to ensure consistency, scalability, and security across all Azure environments while enabling teams to deploy infrastructure efficiently.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Repository Structure

The repository is organized into the following key directories:

- **`modules/`**: Contains reusable Terraform modules for provisioning specific Azure resources.
- **`platforms/`**: Includes platform-specific configurations for applications or environments (e.g., dev, staging, production).
- **`shared/`**: Contains shared infrastructure deployments that are used across multiple platforms or applications.
- **`util/`**: Provides utility scripts for environment setup, Terraform state management, and other helper tasks.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Getting Started

To get started with this repository:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-organization/azure-infra.git
   cd azure-infra
   ```

2. Install the required tools:
   - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - [Terraform](https://developer.hashicorp.com/terraform/downloads)

3. Navigate to the desired directory (e.g., `modules`, `platforms`, or `shared`) and follow the instructions in the corresponding `README.md` file.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Modules

The `modules/` directory contains reusable Terraform modules for provisioning Azure resources. Each module is self-contained and includes its own `README.md` with usage instructions.

### Available Modules:
- **`containers/`**: Modules for managing Azure Kubernetes Service (AKS) and container registries.
- **`databases/`**: Modules for provisioning Azure databases such as PostgreSQL and Redis.
- **`networking/`**: Modules for configuring virtual networks, subnets, and route tables.
- **`security/`**: Modules for managing Azure Key Vault and other security-related resources.
- **`storage/`**: Modules for provisioning Azure storage accounts and related resources.

Refer to the `README.md` files in each module directory for detailed usage instructions.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Platforms

The `platforms/` directory contains platform-specific configurations for deploying infrastructure tailored to specific applications or environments (e.g., dev, staging, production). These configurations leverage the reusable modules in the `modules/` directory.

### Example Platforms:
- **`platforms/dev/`**: Development environment configurations.
- **`platforms/prod/`**: Production environment configurations.

Each platform directory includes its own `README.md` with deployment instructions.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Shared Deployments

The `shared/` directory contains Terraform configurations for provisioning shared infrastructure resources that are used across multiple platforms or applications.

### Example Shared Resources:
- Centralized virtual networks and subnets.
- Shared Azure Key Vault for managing secrets and certificates.
- Shared Azure Container Registry (ACR) for container image management.

Refer to the `README.md` in the `shared/` directory for more details.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Utilities

The `util/` directory provides utility scripts to simplify environment setup and Terraform state management.

### Key Scripts:
- **`setenv.ps1`**: PowerShell script for setting environment variables on Windows.
- **`setenv.sh`**: Bash script for setting environment variables on Unix-based systems.

Refer to the `README.md` in the `util/` directory for detailed instructions on using these scripts.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to improve the repository are welcome. Please follow these steps:

1. Fork the repository and create a new branch for your changes.
2. Make your changes and test them thoroughly.
3. Submit a pull request with a detailed description of your changes.

Ensure that your contributions adhere to the organization's coding standards and best practices.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
