# Set static local variables
locals {
  dscMode = "ApplyAndMonitor"
}

# Allow user input to change these variables from Terraform CLI
variable "aascAccountName" {
  default     = ""
  description = "Azure Automation account name"
  type        = string
}
variable "aascServerEndpoint" {
  default     = ""
  description = "Azure Automation endpoint URL"
  type        = string
}
variable "aascAccessKey" {
  default     = ""
  description = "Azure Automation access key"
  type        = string
  sensitive   = true
}

# Create the DSC extension on the webserver and register with out automation account
resource "azurerm_virtual_machine_extension" "dsc_extension" {
  name                       = "Microsoft.Powershell.DSC"
  virtual_machine_id         = azurerm_windows_virtual_machine.web01.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.77"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_windows_virtual_machine.web01]

  settings = <<SETTINGS_JSON
        {
            "configurationArguments": {
                "RegistrationUrl" : "${var.aascServerEndpoint}",
                "NodeConfigurationName" : "FirstConfig.IsWebServer",
                "ConfigurationMode": "${local.dscMode}",
                "RefreshFrequencyMins": 30,
                "ConfigurationModeFrequencyMins": 15,
                "RebootNodeIfNeeded": false,
                "ActionAfterReboot": "continueConfiguration",
                "AllowModuleOverwrite": true
 
            }
        }
  SETTINGS_JSON

  protected_settings = <<PROTECTED_SETTINGS_JSON
    {
        "configurationArguments": {
                "RegistrationKey": {
                    "userName": "NOT_USED",
                    "Password": "${var.aascAccessKey}"
                }
        }
    }
  PROTECTED_SETTINGS_JSON
}
