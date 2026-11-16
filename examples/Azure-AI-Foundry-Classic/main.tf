terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.17.0, < 5.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.15.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "rg-aifoundry-classic-${random_string.unique.result}"
  location = "eastus2"
}

# AI Foundry Hub (Classic) via Cognitive Services AVM module
module "openai" {
  source = "../../"

  name                     = "aifoundry${random_string.unique.result}"
  location                 = azurerm_resource_group.this.location
  parent_id                = azurerm_resource_group.this.id
  sku_name                 = "S0"
  kind                     = "AIServices"
  allow_project_management = true
  custom_subdomain_name    = "aifoundry${random_string.unique.result}"

  tags = {
    scenario    = "ai-foundry-classic"
    environment = "dev"
  }
}

# AI Foundry Project (Classic) via AzAPI
# Using Microsoft.CognitiveServices/accounts/projects mapping as per MS documentation
resource "azapi_resource" "aifoundry_project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = "default-project"
  parent_id = module.openai.resource_id
  location  = azurerm_resource_group.this.location
  depends_on = [
    module.openai
  ]

  schema_validation_enabled = false

  body = {
    properties = {
      description = "A classic AI Foundry project created via AzAPI"
      displayName = "Default Project"
    }
  }
}

# AI Model Deployment on the Project (Optional, can also be done on the Hub)
resource "azapi_resource" "aifoundry_deployment" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2023-05-01"
  name      = "gpt-4o"
  parent_id = module.openai.resource_id # Deployments are managed at the Hub/Account level
  depends_on = [
    module.openai
  ]

  body = {
    sku = {
      name     = "GlobalStandard"
      capacity = 1
    }
    properties = {
      model = {
        format  = "OpenAI"
        name    = "gpt-4o"
        version = "2024-11-20"
      }
    }
  }
}

output "hub_id" {
  value = module.openai.resource_id
}

output "project_id" {
  value = azapi_resource.aifoundry_project.id
}
