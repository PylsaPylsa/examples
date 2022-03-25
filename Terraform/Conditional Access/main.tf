terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.19.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.2"
    }
  }
}

provider "azuread" {
}

data "azuread_client_config" "current" {}

variable "includeCAGroup" {
  type    = string
  default = "All"
}

variable "CAPolicyState" {
  type    = string
  default = "enabledForReportingButNotEnforced"
}