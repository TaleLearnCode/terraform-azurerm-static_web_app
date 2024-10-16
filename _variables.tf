# #############################################################################
# Variables: Static Web Apps
# #############################################################################

variable "static_web_app_location" {
  type        = string
  description = "The Azure Region in which the Static Web App will be created."
}

variable "create_deployment_token_secret" {
  type        = bool
  description = "Indicates whether a secret should be created in the Key Vault to store the deployment token."
  default     = true
}

variable "create_variable_group" {
  type        = bool
  description = "Indicates whether a variable group should be created in Azure DevOps."
  default     = true  
}

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault."
  default     = ""
}

variable "key_vault_id" {
  type        = string
  description = "The identifier of the Key Vault."
}

variable "service_endpoint_id" {
  type        = string
  description = "The identifier of the service endpoint."
}