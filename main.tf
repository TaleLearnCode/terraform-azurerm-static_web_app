# #############################################################################
# Terraform Module: Azure Static Web App
# #############################################################################

module "naming" {
  source  = "TaleLearnCode/naming/azurerm"
  version = "0.0.4-pre"

  resource_type  = "static_web_app"
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
  srv_comp_abbr  = var.srv_comp_abbr
  custom_name    = var.custom_name
  location       = var.location
  environment    = var.environment
}

resource "azurerm_static_web_app" "static_web_app" {
  name                = module.naming.resource_name
  resource_group_name = var.resource_group_name
  location            = var.static_web_app_location
  sku_tier            = "Standard"
  sku_size            = "Standard"
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_key_vault_secret" "deployment_token" {
  count = var.create_deployment_token_secret || var.create_variable_group ? 1 : 0
  
  key_vault_id = var.key_vault_id
  name         = module.naming.resource_name
  value        = azurerm_static_web_app.static_web_app.api_key
  tags         = var.tags
  depends_on = [
    azurerm_static_web_app.static_web_app
  ]
}

resource "azuredevops_variable_group" "static_web_app" {
  count = var.create_variable_group ? 1 : 0

  project_id = var.azuredevops_project_id
  name = "${upper(var.srv_comp_abbr)}-Config-${var.environment}"
  description = "Variable group for ${var.srv_comp_name} configuration"
  allow_access = true
  key_vault {
    name = var.key_vault_name
    service_endpoint_id = var.service_endpoint_id
  }
  variable {
    name = module.naming.resource_name
  }
  depends_on = [
     azurerm_key_vault_secret.deployment_token
  ]
}