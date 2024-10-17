# Azure Key Vault Terraform Module (Azure DevOps)

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)

This module manages an Azure Static Web App using the [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider. Along with managing the Azure Static Web App, the following resources are also managed by this module:

- **Azure DevOps Pipelines variable group** to store secrets used by the associated Azure DevOps Pipeline.
- **Azure Key Vault secret** to store the deployment token (Azure Static Web App API key) to enable the associated Azure DevOps Pipeline to connect to the Azure Static Web App.

## Providers

| Name        | Version |
| ----------- | ------- |
| azurerm     | ~> 4.1  |
| azuredevops | ~> 1.3  |

## Modules

- [Azure Key Vault Secret](..\key_vault_secret\examples\standard\README.md)

## Usage

```hcl
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

For more detailed instructions on using this module, please refer to the appropriate example:

- [Default Example](examples/default/README.md)

## Inputs

| Name                           | Description                                                  | Type        | Default | Required |
| ------------------------------ | ------------------------------------------------------------ | ----------- | ------- | -------- |
| azure_devops_pat               | The Azure DevOps Personal Access Token.                      | string      | N/A     | yes      |
| azuredevops_project_id         | The identifier of the Azure DevOps project.                  | string      | N/A     | yes      |
| create_deployment_token_secret | Indicates whether a secret should be created in the Key Vault to store the deployment token. | bool        | true    | no       |
| create_variable_group          | Indicates whether a variable group should be created in Azure DevOps. | bool        | true    | no       |
| custom_name                    | If set, custom name to use instead of the generated name     | string      | ""      | no       |
| environment                    | The environment within the resources are being deployed to. Valid values are 'dev', 'qa', 'e2e', and 'prod'. | string      | N/A     | yes      |
| key_vault_id                   | The identifier of the Key Vault.                             | string      | N/A     | no       |
| key_vault_name                 | The name of the Key Vault.                                   | string      | ""      | no       |
| location                       | The Azure Region in which all resources will be created.     | string      | N/A     | yes      |
| name_prefix                    | Optional prefix to apply to the generated name.              | string      | ""      | no       |
| name_suffix                    | Optional suffix to apply to the generated name.              | string      | ""      | no       |
| resource_group_name            | The name of the resource group in which all resources will be created. | string      | N/A     | yes      |
| service_endpoint_id            | The identifier of the service endpoint.                      | string      | N/A     | no       |
| srv_comp_abbr                  | The abbreviation of the service component for which the resources are being created. | string      | ""      | no       |
| srv_comp_name                  | The name of the service component for which the resources are being created. | string      | N/A     | yes      |
| static_web_app_location        | The Azure Region in which the Static Web App will be created. | string      | N/A     | no       |
| tags                           | A map of tags to apply to all resources.                     | map(string) | {}      | no       |

## Outputs

| Name                                | Description                                                  |
| ----------------------------------- | ------------------------------------------------------------ |
| azuredevops_variable_group          | The Azure DevOps variable group.                             |
| key_vault_secret                    | The Key Vault secret holding the Azure Static Web App API key. |
| static_web_app                      | The managed Azure Static Web App.                            |
| static_web_app_private_link_address | The private link address of the Static Web App.              |

## Naming Guidelines

### Key Vault

| Guideline                       |                                              |
| ------------------------------- | -------------------------------------------- |
| Resource Type Identifier        | stapp                                        |
| Scope                           | Global                                       |
| Max Overall Length              | 2 - 60 characters                            |
| Allowed Component Name Length * | 43 characters                                |
| Valid Characters                | Alphanumeric and hyphens                     |
| Regex                           | `^[a-zA-Z0-9][a-zA-Z0-9-]{0,58}[a-zA-Z0-9]$` |

> Allowed Component Name Length is a combination of the `srv_comp_abbr`, `name_prefix`, and `name_suffix` or the `custom_name` if used.
