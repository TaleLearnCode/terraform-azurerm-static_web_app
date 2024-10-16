# #############################################################################
# Variables: Environment
# #############################################################################

variable "location" {
  type        = string
  description = "The Azure Region in which all resources will be created."
}

variable "environment" {
  type        = string
  description = "The environment within the resources are being deployed to. Valid values are 'dev', 'qa', 'e2e', and 'prod'."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which all resources will be created."
}

variable "azuredevops_project_id" {
  type        = string
  description = "The identifier of the Azure DevOps project."
}

variable "azure_devops_pat" {
  type        = string
  description = "The Azure DevOps Personal Access Token."
}