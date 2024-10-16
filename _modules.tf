# #############################################################################
# Modules
# #############################################################################

module "azure_regions" {
  source = "git::git@ssh.dev.azure.com:v3/JasperEnginesTransmissions/JETDEV/TerraformModule_AzureRegions"
  azure_region = var.location
}