<a name="readme-top"></a>

# Terraform Module: Azure Kubernetes Service (AKS)

- [Terraform Module: Azure Kubernetes Service (AKS)](#terraform-module-azure-kubernetes-service-aks)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Input Variables Overview](#input-variables-overview)
    - [Container Registry (`acr`)](#container-registry-acr)
    - [Key Vault (`kv`)](#key-vault-kv)
    - [Node Pool (`node_pool`)](#node-pool-node_pool)
      - [Default Node Pool Configuration](#default-node-pool-configuration)
      - [Additional Node Pools Configuration](#additional-node-pools-configuration)
    - [Private Endpoint (`pe`)](#private-endpoint-pe)
    - [Resource Group (`rg`)](#resource-group-rg)
    - [Storage (`storage`)](#storage-storage)
    - [Upgrade Channel (`upgrade_channel`)](#upgrade-channel-upgrade_channel)
    - [Virtual Network (`vnet`)](#virtual-network-vnet)
  - [Module Components](#module-components)
  - [Usage](#usage)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

This module provisions an Azure Kubernetes Service (AKS) cluster with advanced options including a configurable node pool, a private endpoint for secure API server connectivity, and virtual network integration. It is designed for production-grade deployments and simplifies the management of your Kubernetes clusters on Azure. The module also supports integration with Azure Container Registry, Key Vault, external storage resources, and configurable upgrade channels.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli): Installed and authenticated with sufficient permissions.
- [Terraform](https://developer.hashicorp.com/terraform/downloads): >= 1.0  
  - Provider: [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (>= 3.0)

_**Note**: This module may require provider aliases if deploying resources across multiple scopes._

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Input Variables Overview

| Name              | Type       | Required | Default   | Description                                                              |
|-------------------|------------|----------|-----------|--------------------------------------------------------------------------|
| `acr`             | `object`   | No       | n/a       | Container Registry integration for storing container images.             |
| `kv`              | `object`   | No       | n/a       | Key Vault integration for managing secrets and certificates.             |
| `name`            | `string`   | Yes      | n/a       | The name to assign to the AKS cluster.                                   |
| `node_pool`       | `object`   | Yes      | See below | Configuration for the node pools of the cluster (default is required).   |
| `pe`              | `object`   | Yes      | n/a       | Configuration for the private endpoint used for secure API connectivity. |
| `rg`              | `object`   | Yes      | n/a       | Resource Group details for the deployment.                               |
| `storage`         | `object`   | No       | n/a       | External storage integration (e.g., for logs or state).                  |
| `upgrade_channel` | `object`   | No       | See below | Specifies the upgrade channel for automatic cluster updates.             |
| `vnet`            | `object`   | Yes      | n/a       | Virtual Network settings for network integration.                        |
| `tags`            | `map(any)` | No       | n/a       | A map of tags to assign to the deployed resources.                       |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Container Registry (`acr`)

This variable configures the Azure Container Registry (ACR) to be used by the AKS cluster.

| Attribute | Type     | Description                                |
|-----------|----------|--------------------------------------------|
| `id`      | `string` | The resource ID of the Container Registry. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Key Vault (`kv`)

This variable configures the Azure Key Vault for managing secrets and certificates for the cluster.

| Attribute | Type     | Description                       |
|-----------|----------|-----------------------------------|
| `id`      | `string` | The resource ID of the Key Vault. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Node Pool (`node_pool`)

The `node_pool` variable defines the configuration for the node pools of the cluster. It is an object with the following structure:

#### Default Node Pool Configuration

| Attribute                 | Type     | Required | Default             | Description                                                  |
|---------------------------|----------|----------|---------------------|--------------------------------------------------------------|
| `vm_size`                 | `string` | Yes      | `"Standard_D2s_v5"` | The virtual machine size for nodes in the default node pool. |
| `node_count`              | `number` | No       | n/a                 | The static number of nodes in the default node pool.         |
| `auto_scaling.enabled`    | `bool`   | No       | n/a                 | Whether auto-scaling is enabled for the default node pool.   |
| `auto_scaling.max_count`  | `number` | No       | n/a                 | Maximum number of nodes when auto-scaling is enabled.        |
| `auto_scaling.min_count`  | `number` | No       | n/a                 | Minimum number of nodes when auto-scaling is enabled.        |

#### Additional Node Pools Configuration

This block is optional and accepts a map for additional node pools.

| Attribute                 | Type     | Required | Default | Description                                           |
|---------------------------|----------|----------|---------|-------------------------------------------------------|
| `vm_size`                 | `string` | Yes      | n/a     | The virtual machine size for nodes in the node pool.  |
| `node_count`              | `number` | No       | n/a     | The static number of nodes in the node pool.          |
| `auto_scaling.enabled`    | `bool`   | No       | n/a     | Whether auto-scaling is enabled for the node pool.    |
| `auto_scaling.max_count`  | `number` | No       | n/a     | Maximum number of nodes when auto-scaling is enabled. |
| `auto_scaling.min_count`  | `number` | No       | n/a     | Minimum number of nodes when auto-scaling is enabled. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Private Endpoint (`pe`)

Configuration for secure private network access.

| Attribute | Type     | Description                                                     |
|-----------|----------|-----------------------------------------------------------------|
| `rg.name` | `string` | The name of the resource group that hosts the private DNS zone. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Resource Group (`rg`)

Resource group details for deploying the cluster.

| Attribute  | Type     | Description                                                                 |
|------------|----------|-----------------------------------------------------------------------------|
| `id`       | `string` | The resource group identifier (e.g., `/subscriptions/.../myResourceGroup`). |
| `location` | `string` | The Azure region of the resource group (e.g., `eastus`).                    |
| `name`     | `string` | The name of the resource group.                                             |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Storage (`storage`)

This variable configures an external storage account to be used by the cluster (for logs, state, etc.). It is an object with the following attribute:

| Attribute | Type     | Description                             |
|-----------|----------|-----------------------------------------|
| `id`      | `string` | The resource ID of the storage account. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Upgrade Channel (`upgrade_channel`)

This variable specifies the upgrade channel for automatic cluster updates. It is an object with the following attributes:

| Attribute   | Type     | Required | Default    | Description                                                                                  |
|-------------|----------|----------|------------|----------------------------------------------------------------------------------------------|
| `automatic` | `string` | Yes      | `"stable"` | Specifies the automatic upgrade channel (e.g., "stable", "rapid", "preview").                |
| `node_os`   | `string` | Yes      | `"None"`   | Specifies the upgrade channel for the node operating system; "None" indicates no OS upgrade. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Virtual Network (`vnet`)

Virtual network integration details.

| Attribute       | Type     | Description                                                 |
|-----------------|----------|-------------------------------------------------------------|
| `id`            | `string` | The identifier of the Virtual Network.                      |
| `subnet.id`     | `string` | The identifier of the Subnet within the Virtual Network.    |
| `name`          | `string` | The name of the resource group hosting the Virtual Network. |
| `route_table`   | `object` | *(Optional)* Configuration for an associated route table.   |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Module Components

This module is composed of the following files:

- **main.tf**:  
  Contains the primary resource definitions for the AKS cluster, including the creation of the cluster, node pools, and associated networking resources.

- **variables.tf**:  
  Declares all the input variables required by the module (as detailed above).

- **outputs.tf**:  
  Defines the outputs for the module, such as the cluster ID and name, for use in downstream configurations.

- **provider.tf**:  
  Configures the AzureRM provider and any necessary provider aliases for multi-scope deployments.

*(Additional helper files or local variables may be included as needed.)*

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

### Example Terraform Configuration

```hcl
module "aks" {
  source = "../../modules/containers/aks"
  name   = format("aks-%s-%s-%03d", var.platform, var.env, 1)

  acr = { id = local.container.registry.id }
  kv  = { id = module.kv.id }

  node_pool = {
    default = {
      vm_size = "Standard_D2s_v5"
    }
    additional = {
      ingress = {
        vm_size = "Standard_D2s_v5"
      }
      application = {
        vm_size = "Standard_D2s_v5"
      }
    }
  }

  pe = local.pe
  rg = local.rg
  storage = { id = module.st.id }
  tags = local.tags

  upgrade_channel = {
    automatic = "stable"
    node_os   = "None"
  }

  vnet = {
    id = local.vnet.id
    subnet = {
      id = module.snet.id
    }
    route_table = {
      id = module.rt.id
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Outputs

The module provides these outputs:

| Name   | Description                                        |
|--------|----------------------------------------------------|
| `id`   | The unique identifier of the deployed AKS cluster. |
| `name` | The name assigned to the AKS cluster.              |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to enhance the module’s functionality or documentation are welcome. Please open an issue or submit a pull request with your suggestions. Remember to update tests as appropriate.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Accepted Conventions

- [Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Tagging Strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez "eliezerchavez") - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
