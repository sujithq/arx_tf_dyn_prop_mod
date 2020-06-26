provider "azurerm" {
  version = "=2.6.0"
  features {}
}

locals {
  defaultName = "${var.stageName}-${var.project}"
}

resource "azurerm_data_factory" "gendfawithvsts" {
  count=var.stageName == "d" ? 1 : 0
  name                = "${local.defaultName}"
  resource_group_name = var.resourceGroupName
  location            = var.location 
  identity {
        type= "SystemAssigned"
  }
  vsts_configuration {
      account_name        = var.alldivision_dfa_accountname
      branch_name         = var.alldivision_dfa_branchname 
      project_name        = var.alldivision_dfa_projectname
      repository_name     = var.alldivision_dfa_repositoryname
      root_folder         = var.alldivision_dfa_rootfolder
      tenant_id           = var.alldivision_dfa_tenantid    
  }
  tags =  {
    "Cost Center"="BU DATA"
  }
}

resource "azurerm_data_factory_integration_runtime_managed" "gendfawithvsts-ir" {
  count = var.stageName == "d" ? 1 : 0
  name                = "ir-${local.defaultName}"
  data_factory_name   = azurerm_data_factory.gendfawithvsts[0].name
  resource_group_name = var.resourceGroupName
  location            = var.location 
  node_size = "Standard_D8_v3"
  edition = "Standard"
}

resource "azurerm_data_factory" "gendfanovsts" {
  count = var.stageName == "d" ? 0 : 1
  name                = "df-${local.defaultName}"
  resource_group_name = var.resourceGroupName
  location            = var.location 
  identity {
        type= "SystemAssigned"
  }
  tags =  {
    "Cost Center"="BU DATA"
  }
}

resource "azurerm_data_factory_integration_runtime_managed" "gendfanovsts-ir" {
  count=var.stageName == "d" ? 0 : 1
  name                = "ir-${local.defaultName}"
  data_factory_name   = azurerm_data_factory.gendfanovsts[0].name
  resource_group_name = var.resourceGroupName
  location            = var.location 
  node_size = "Standard_D8_v3"
  edition = "Standard"
}