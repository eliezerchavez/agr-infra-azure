<a name="readme-top"></a>

# Azure Infrastructure as Code (IaC) Repository

- [Azure Infrastructure as Code (IaC) Repository](#azure-infrastructure-as-code-iac-repository)
  - [Description](#description)
  - [Repository Structure](#repository-structure)
  - [Getting Started](#getting-started)
  - [Modules](#modules)
    - [Available Modules:](#available-modules)
  - [Platforms](#platforms)
    - [Example Platforms:](#example-platforms)
  - [Shared Deployments](#shared-deployments)
    - [Examples of Shared Resources:](#examples-of-shared-resources)
  - [Utilities](#utilities)
    - [Key Utility Scripts:](#key-utility-scripts)
  - [Contributing](#contributing)
    - [Accepted Conventions](#accepted-conventions)
  - [Credits](#credits)

---

## Description

This repository serves as the organization's central Infrastructure as Code (IaC) hub for managing Azure resources and deployments. It provides reusable Terraform modules, structured platform configurations, shared infrastructure solutions, and utility scripts, all aligned with Azure best practices.

The primary goals of this repository include:

- **Consistency** across deployments.
- **Scalability** to handle diverse workloads efficiently.
- **Security and compliance** adhering to industry standards.
- **Efficient and standardized workflows** for infrastructure provisioning.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Repository Structure

The repository is structured into the following directories for clarity, maintainability, and ease of use:

- **`modules/`**:  
  Reusable Terraform modules to provision Azure services and components.

- **`platforms/`**:  
  Environment or application-specific deployments (e.g., dev, staging, prod) leveraging modules.

- **`shared/`**:  
  Infrastructure resources shared across multiple platforms and environments.

- **`util/`**:  
  Helper scripts and utilities for environment setup, Terraform state management, and common tasks.

Each directory includes comprehensive `README.md` documentation detailing usage and deployment procedures.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Getting Started

To begin working with this repository, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-organization/azure-infra.git
   cd azure-infra
   ```

2. **Install required tools**:
   - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0)

3. **Authenticate to Azure**:
   ```bash
   az login
   az account set --subscription "<subscription-id>"
   ```

4. **Navigate to your desired deployment** (`modules`, `platforms`, or `shared`) and follow its specific `README.md` instructions.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Modules

The `modules/` directory hosts modularized Terraform code, each encapsulating best-practice configurations for Azure resources.

### Available Modules:

- **`ai_ml/`**:  
  Modules for Azure Cognitive Services, Machine Learning Workspace, Bot Services, and Cognitive Search.

- **`containers/`**:  
  Modules for Azure Kubernetes Service (AKS) and Azure Container Registry (ACR).

- **`databases/`**:  
  Modules for Azure PostgreSQL Flexible Server and Azure Redis Cache.

- **`mgmt/`**:  
  Modules for Azure Application Insights and related monitoring tools.

- **`networking/`**:  
  Modules for VNets, Subnets, Route Tables, and Network Security.

- **`security/`**:  
  Modules for managing secure resources, including Azure Key Vault.

- **`storage/`**:  
  Modules for provisioning Azure Storage Accounts and related components.

Refer to each module’s `README.md` file for detailed usage instructions and examples.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Platforms

The `platforms/` directory contains Terraform configurations for environment-specific deployments utilizing the standardized modules.

### Example Platforms:

- **`platforms/open/`**:  
  Reference architecture for Azure Open Platform, supporting containerized workloads, machine learning, cognitive services, and managed databases.

- **`platforms/dev/`**:  
  Development environment deployments.

- **`platforms/prod/`**:  
  Production-grade configurations with enhanced security, scalability, and high availability.

Each platform directory provides a detailed `README.md` outlining provisioning instructions and configurations.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Shared Deployments

The `shared/` directory includes infrastructure deployments intended for reuse across multiple platforms or teams.

### Examples of Shared Resources:

- Centralized Virtual Networks (VNets), Subnets, and Route Tables.
- Common Azure Key Vault for centralized secrets management.
- Shared Azure Container Registry for Docker image storage and retrieval.

Check the `README.md` in the `shared/` directory for detailed guidance on utilizing and managing shared resources.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Utilities

The `util/` directory provides scripts and utilities to simplify infrastructure management workflows and setup.

### Key Utility Scripts:

- **`setenv.sh`**:  
  Bash script for environment variable setup on Unix-based systems.

- **`setenv.ps1`**:  
  PowerShell script for Windows-based environment variable setup.

- Scripts for managing Terraform state, automation tasks, and infrastructure validation.

Refer to the utilities' `README.md` for comprehensive usage instructions.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

We welcome contributions! To submit improvements or fixes:

1. **Fork** the repository and **create a feature branch**.
2. Implement your changes and perform thorough **local testing**.
3. Submit a clearly described **pull request (PR)**.

Please follow Azure's best practices and repository standards outlined below.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

Ensure your code adheres to these guidelines for consistency, maintainability, and security.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) – _Initial Work, Documentation, Terraform Module Design, and Implementation._

<p align="right">(<a href="#readme-top">back to top</a>)</p>
