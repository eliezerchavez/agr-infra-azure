<a name="readme-top"></a>

# Azure Infrastructure as Code (IaC)

- [Azure Infrastructure as Code (IaC)](#azure-infrastructure-as-code-iac)
  - [Description](#description)
  - [Repository Structure](#repository-structure)
  - [Platforms](#platforms)
    - [Open Platform](#open-platform)
    - [AI Platform](#ai-platform)
  - [Modules](#modules)
  - [Shared Resources](#shared-resources)
  - [Usage](#usage)
  - [Contributing](#contributing)
    - [Accepted Conventions](#accepted-conventions)
  - [Credits](#credits)

---

## Description

This repository provides a comprehensive, modular, and production-grade Infrastructure as Code (IaC) framework for provisioning and managing Azure environments using Terraform.

It includes:
- Reusable, best-practice Terraform modules for Azure
- Platform definitions for core and AI-centric cloud infrastructure
- Shared components (e.g., VNet, ACR, Key Vault) used across all environments

All configurations follow Azure naming conventions, tagging strategy, and deployment standards — empowering teams to rapidly spin up secure, scalable, and maintainable infrastructure.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Repository Structure

| Folder            | Description                                                                                        |
|-------------------|----------------------------------------------------------------------------------------------------|
| `platform/`       | Complete environment blueprints: `open/` for general workloads and `ai/` for ML/AI infrastructure. |
| `modules/`        | Reusable and composable Terraform modules for Azure services (e.g., AKS, PostgreSQL, Key Vault).   |
| `shared/`         | Shared infrastructure components used across platforms (e.g., hub networking, shared ACR, KV).     |
| `util/`           | Utility scripts to simplify initialization and deployment workflows.                               |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Platforms

### [Open Platform](./platform/open/)

The foundation for deploying scalable, secure, and cloud-native Azure infrastructure.  
Includes:
- AKS, ACR
- PostgreSQL Flexible Server
- Redis Cache
- Key Vault, Storage, Monitoring
- Fully integrated networking (VNet, NSGs, RTs, DNS)

> The AI Platform extends the Open Platform.

---

### [AI Platform](./platform/ai/)

Extends the Open Platform with capabilities tailored for artificial intelligence and machine learning.  
Includes:
- Azure Cognitive Services (OpenAI, Language, Form Recognizer)
- Azure Machine Learning Workspace
- Azure Cognitive Search
- Secure endpoints, identity, and private DNS integrations

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Modules

All reusable Terraform modules reside in the [`modules/`](./modules/) directory.  
They are grouped by category and designed to be composable, readable, and production-ready.

| Category       | Examples                                                                                                                    |
|----------------|-----------------------------------------------------------------------------------------------------------------------------|
| AI & ML        | [Bot Service](./modules/ai_ml/bot/), [Cognitive Services](./modules/ai_ml/cognitive/), [ML Workspace](./modules/ai_ml/mlw/) |
| Containers     | [AKS](./modules/containers/aks/), [ACR](./modules/containers/acr/)                                                          |
| Databases      | [PostgreSQL Flexible](./modules/databases/postgres_flexible_server/), [Redis](./modules/databases/redis_cache/)             |
| Monitoring     | [App Insights](./modules/mgmt/appi/), [Log Analytics](./modules/networking/log/)                                            |
| Networking     | [Subnets](./modules/networking/subnet/), [Route Tables](./modules/networking/route_table/)                                  |
| Security       | [Key Vault](./modules/security/key_vault/)                                                                                  |
| Storage        | [Storage Accounts](./modules/storage/storage_account/)                                                                      |

Each module contains:
- A scoped `README.md`
- Input/output variables
- Example usage

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Shared Resources

Shared resources live under the [`shared/`](./shared/) directory and support multi-environment architecture.

These include:
- Centralized VNets and Subnets
- Shared Azure Container Registry (ACR)
- Global Key Vault
- DNS zones and shared networking components

They are designed to be provisioned once and referenced across platforms.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

```bash
# Set environment variables
source util/setenv.sh

# Example: Open Platform - Corporate Dev
terraform -chdir=terraform/platform/open init \
  -backend-config="key=platform/open/corporate/dev/terraform.tfstate"

terraform -chdir=terraform/platform/open plan -var-file=vars/dev.tfvars
terraform -chdir=terraform/platform/open apply -var-file=vars/dev.tfvars -auto-approve
```

Update the `<platform>/<business_unit>/<env>` values to match your specific deployment targets.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to improve module functionality, platform capabilities, or documentation are welcome.  
Please submit issues or pull requests with clearly described changes and appropriate testing.

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) – _Initial Work, Architecture, and Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
