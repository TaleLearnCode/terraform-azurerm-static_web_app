# #############################################################################
# Providers Configuration
# #############################################################################

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