terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "769731a1-d9a4-4aa7-9d01-77c900581095"
}
