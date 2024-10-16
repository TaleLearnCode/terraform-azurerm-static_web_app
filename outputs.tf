 #############################################################################
# Outputs
# #############################################################################

output "static_web_app" {
  value = azurerm_static_web_app.static_web_app
  description = "The managed Azure Static Web App."
}

output "static_web_app_private_link_address" {
  value = replace(azurerm_static_web_app.static_web_app.default_host_name, regex("^(.*?)\\.", azurerm_static_web_app.static_web_app.default_host_name)[0], "privatelink")
  description = "The private link address of the Static Web App."
}

output "key_vault_secret" {
  value = azurerm_key_vault_secret.deployment_token[0]
  description = "The Key Vault secret holding the Azure Static Web App API key."
}

output "azuredevops_variable_group" {
  value = azuredevops_variable_group.static_web_app[0]
  description = "The Azure DevOps variable group."
}