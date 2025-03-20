locals {
  avangrid = {
    corporate = {
      subscriptions = {
        prd = { id = "29752ee9-d1d0-4461-b5af-135970d01399" }
        npd = { id = "f6bb1eb7-a78f-40cf-abb0-ea45174b35da" }
      }
      network = {
        prd = {
          rg  = { name = "RG-CORPO-NETWORKING" }
          int = { name = var.location == "eastus" ? "VNET-CORPO-PRODUCTION" : "VNET-CORPO-PRODUCTION-${var.location}" }
          dmz = {
            inn = {
              name = var.location == "eastus" ? "VNET-CORPO-PRODUCTION-INNER" : "VNET-CORPO-PRODUCTION-INNER-${var.location}"
            }
            out = {
              name = var.location == "eastus" ? "VNET-CORPO-PRODUCTION-OUTER" : "VNET-CORPO-PRODUCTION-OUTER-${var.location}"
            }
          }
        }
        npd = {
          rg  = { name = "RG-CORPO-NETWORKING" }
          int = { name = var.location == "eastus" ? "VNET-CORPO-NONPRODUCTION" : "VNET-CORPO-NONPRODUCTION-${var.location}" }
          dmz = {
            inn = {
              name = var.location == "eastus" ? "VNET-CORPO-NONPRODUCTION-INNER" : "VNET-CORPO-NONPRODUCTION-INNER-${var.location}"
            }
            out = {
              name = var.location == "eastus" ? "VNET-CORPO-NONPRODUCTION-OUTER" : "VNET-CORPO-NONPRODUCTION-OUTER-${var.location}"
            }
          }
        }
      }
    }
    networks = {
      subscriptions = {
        prd = { id = "8ccbbf39-0ba2-45aa-a735-10228f07ff2e" }
        npd = { id = "e5e8edf1-eb17-42c2-9925-5a771c8f1b7f" }
      }
      network = {
        prd = {
          rg  = { name = "rg-networks-production-networking" }
          int = { name = var.location == "eastus" ? "VNET-NETWORKS-PRODUCTION" : "VNET-NETWORKS-PRODUCTION-${var.location}" }
        }
        npd = {
          rg  = { name = "rg-networks-nonproduction-networking" }
          int = { name = var.location == "eastus" ? "VNET-NETWORKS-NONPRODUCTION" : "VNET-NETWORKS-NONPRODUCTION-${var.location}" }
        }
      }
    }
    renewables = {
      subscriptions = {
        prd = { id = "5c13fa52-fefa-490c-9790-14363de6f640" }
        npd = { id = "3f12ce55-0322-47e4-a8c2-d04d80ed53df" }
      }
      network = {
        prd = {
          rg  = { name = "rg-renewables-production-networking" }
          int = { name = var.location == "eastus" ? "VNET-RENEWABLES-PRODUCTION" : "VNET-RENEWABLES-PRODUCTION-${var.location}" }
        }
        npd = {
          rg  = { name = "rg-renewables-nonproduction-networking" }
          int = { name = var.location == "eastus" ? "VNET-RENEWABLES-NONPRODUCTION" : "VNET-RENEWABLES-NONPRODUCTION-${var.location}" }
        }
      }
    }
    shared = {
      subscriptions = {
        all = { id = "6b48db3f-9a9a-4ea2-9eb7-356d9852accd" }
      }
    }

  }

  pe = {
    rg = {
      name = "RG-COMMON-NETWORKING-AZDNS"
    }
  }

  rg = {
    id       = azurerm_resource_group.this.id
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }

  tags = {
    APP_ID          = "AP40702"
    APP_NAME        = "AP_PLT_AZURE_CLOUD"
    "BUSINESS UNIT" = "CORPORATION USA"
    ENTERPRISE      = "AVANGRID"
    WORKGROUP       = "USA-INFO TECHNOLOGY"
  }

  vnet = {
    id = data.azurerm_virtual_network.this.id
  }

}
