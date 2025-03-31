resource "azurerm_resource_group" "this" {
  name     = format("rg-%s-%s-%03d", var.platform, var.env, 1)
  location = var.location

  tags = local.tags

  lifecycle {
    ignore_changes = [tags]
  }

}

data "azurerm_network_security_group" "this" {
  name                = "${local.vnet.name}-NSG-NOENTRY"
  resource_group_name = local.vnet.rg.name

}

module "snet" {
  source = "../../modules/networking/snet"

  address_prefix = var.net.snet.address_prefix

  name = format("${local.vnet.name}-SNET-AKS-%s-%s", upper(var.platform), upper(var.env))

  rg = local.vnet.rg

  service_endpoints = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]

  vnet = {
    id   = local.vnet.id
    name = local.vnet.name
  }

}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = module.snet.id
  network_security_group_id = data.azurerm_network_security_group.this.id

}

module "rt" {
  source = "../../modules/networking/rt"

  name = format("${local.vnet.name}-UDR-AKS-%s-%s", upper(var.platform), upper(var.env))

  rg = local.vnet.rg

  routes = var.net.rt.routes

  tags = local.tags

}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = module.snet.id
  route_table_id = module.rt.id
}



module "kv" {
  source = "../../modules/security/kv"

  name = format("kv-%s-%s", var.platform, var.env)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-IT_TOOLS"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}

module "st" {
  source = "../../modules/storage/st"

  name = format("sa%s%s%03d", var.platform, var.env, 1)

  pe = local.pe

  rg = local.rg

  subresource_names = ["blob", "file"]

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-GENERAL"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}

module "aks" {
  source = "../../modules/containers/aks"
  name   = format("aks-%s-%s-%03d", var.platform, var.env, 1)

  acr = { id = local.container.registry.id }

  kv = { id = module.kv.id }

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

module "pgsql" {
  source = "../../modules/databases/postgres/flexible"
  name   = format("psql-%s-%s-%03d", var.platform, var.env, 1)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-POSTGRESQL"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}

module "redis" {
  source = "../../modules/databases/redis"
  name   = format("redis-%s-%s", var.platform, var.env)

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-DATABASES"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}

module "oai" {
  source = "../../modules/ai_ml/oai"
  name   = format("oai-%s-%s", var.platform, var.env)

  sku_name = "S0"

  pe = local.pe

  rg = local.rg

  tags = local.tags

  vnet = {
    id = local.vnet.id
    subnet = {
      id = "${local.vnet.id}/subnets/${local.vnet.name}-SNET-AZUREAI"
    }
  }

  providers = {
    azurerm.app = azurerm
    azurerm.hub = azurerm.hub
  }

}


