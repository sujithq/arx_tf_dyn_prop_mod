terraform {
}

provider "azurerm" {
  version = "=2.6.0"
  features {}
}

data "azurerm_client_config" "current" {}

locals {
  defaultName = "${var.stageName}-${var.project}"
  defaultLocation= "West Europe"
  alldivision_dfa_accountname = (var.stageName == "d" ? "acme" : null)
  alldivision_dfa_branchname = (var.stageName == "d" ? "DEV" : null)
  alldivision_dfa_projectname = (var.stageName == "d" ? "acme data platform" : null)
  alldivision_dfa_repositoryname = (var.stageName == "d" ? "acme data platform" : null)
  alldivision_dfa_rootfolder = (var.stageName == "d" ? "/Code/general/Datafactory" : null)
  alldivision_dfa_tenantid = (var.stageName == "d" ? data.azurerm_client_config.current.tenant_id : null)
}

resource "azurerm_resource_group" "rg"{
    name = "rg-${local.defaultName}"
    location = local.defaultLocation
}

module "df" {
  source = "./modules/df"
  stageName = var.stageName
  project = var.project
  resourceGroupName = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  alldivision_dfa_accountname = local.alldivision_dfa_accountname
  alldivision_dfa_branchname = local.alldivision_dfa_branchname
  alldivision_dfa_projectname = local.alldivision_dfa_projectname
  alldivision_dfa_repositoryname = local.alldivision_dfa_repositoryname
  alldivision_dfa_rootfolder = local.alldivision_dfa_rootfolder
  alldivision_dfa_tenantid = local.alldivision_dfa_tenantid
}

resource "azurerm_key_vault" "genkeyvault"{
  name                = "kv-${local.defaultName}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  enabled_for_template_deployment = true 
  soft_delete_enabled = false 
  sku_name = "standard"
  tags =  {
    "Cost Center"="BU DATA"
  }
  dynamic "access_policy" {
    for_each = [for k in var.kv_policies: {
      object_id = k.object_id
      key_permissions = k.key_permissions
      secret_permissions = k.secret_permissions
    }]
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value.object_id == "data.azurerm_client_config.current.object_id" ? data.azurerm_client_config.current.object_id : (access_policy.value.object_id == "azurerm_data_factory.gendfanovsts[0].identity[0].principal_id" ? module.df.principal_id : access_policy.value.object_id)
      key_permissions = access_policy.value.key_permissions
      secret_permissions = access_policy.value.secret_permissions
    }
  }
} 