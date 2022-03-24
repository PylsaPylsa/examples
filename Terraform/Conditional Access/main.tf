terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.19.1"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.7.2"
    }
  }
}

provider "azuread" {
  tenant_id = "e074231f-d031-4f0f-ad84-d72157130967"
}

data "azuread_client_config" "current" {}
