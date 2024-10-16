terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "~> 1.3"
    }
  }
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/MyOrganization"
  personal_access_token ="00000000-0000-0000-0000-000000000000"
}

data "azurerm_resource_group" "existing" {
  name = "existing"
}

data "azurerm_key_vault" "existing" {
  name                = "existing"
  resource_group_name = data.azurerrm_resource_group.existing.name
}

data "azuredevops_project" "jetdev" {
  name = "MyProject"
}

data "azuredevops_serviceendpoint_azurerm" "keyvault" {
  project_id = data.azuredevops_project.jetdev.id
  service_endpoint_name = "ExistingServiceEndpoint"
}

module "static_web_app" {
  source = "aleLearnCode/static_web_app/azurerm"
  version = "0.0.1-pre"
  providers = {
    azurerm     = azurerm
    azuredevops = azuredevops
  }

  resource_group_name            = data.azurerm_resource_group.existing.name
  static_web_app_location        = data.azurerm_resource_group.existing.location
  create_deployment_token_secret = true
  create_variable_group          = true
  key_vault_id                   = data.azurerm_key_vault.existing.id
  key_vault_name                 = data.azurerm_key_vault.existing.name
  service_endpoint_id            = data.azuredevops_serviceendpoint_azurerm.keyvault.id
  azuredevops_project_id         = data.azuredevops_project.jetdev.id
  location                       = data.azurerm_resource_group.existing.location
  environment                    = var.environment
  srv_comp_abbr                  = var.srv_comp_abbr
  srv_comp_name                  = var.srv_comp_abbr
  azure_devops_pat               = var.azure_devops_pat
}