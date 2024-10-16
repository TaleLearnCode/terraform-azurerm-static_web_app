# Example: Azure Static Web App

This module manages an Azure Static Web App using the [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider.  This example shows how to use the module to manage an Azure Key Vault Secret.

## Example Usage

```hcl
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
```

You are specifying three values:

- **resource_group_name**: The name of the resource group in which all resources will be created.
- **static_web_app_location**: The Azure Region in which the Static Web App will be created.
- **create_deployment_token_secret**: Indicates whether a secret should be created in the Key Vault to store the deployment token.
- **create_variable_group**: Indicates whether a variable group should be created in Azure DevOps.
- **key_vault_id**: The identifier of the Key Vault.
- **key_vault_name**: The name of the Key Vault.
- **service_endpoint_id**: The identifier of the service endpoint.
- **azuredevops_project_id**: The identifier of the Azure DevOps project.
- **location**: The Azure Region in which all resources will be created.
- **environment**: The environment within the resources are being deployed to. Valid values are 'dev', 'qa', 'e2e', and 'prod'.
- **srv_comp_abbr**: The abbreviation of the service component for which the resources are being created.
- **srv_comp_name**: The name of the service component for which the resources are being created.
- **azure_devops_pat**: The Azure DevOps Personal Access Token.
