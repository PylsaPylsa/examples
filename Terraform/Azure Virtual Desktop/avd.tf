resource "azurerm_virtual_desktop_workspace" "avdworkspace" {
  name                = var.workspace
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  friendly_name       = var.workspace
  description         = var.workspace
}

resource "time_rotating" "avdtoken" {
  rotation_days = 30
}

resource "azurerm_virtual_desktop_host_pool" "avdhostpool" {
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  name                     = var.hostpool
  friendly_name            = var.hostpool
  validate_environment     = false
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "${var.hostpool} HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = 16
  load_balancer_type       = "BreadthFirst"
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "avdhostpoolregistration" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avdhostpool.id
  expiration_date = time_rotating.avdtoken.rotation_rfc3339
}

resource "azurerm_virtual_desktop_application_group" "avddag" {
  resource_group_name = azurerm_resource_group.rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.avdhostpool.id
  location            = var.location
  type                = "Desktop"
  name                = "Terraform-DesktopApplicationGroup"
  friendly_name       = "Full Desktop"
  description         = "Full Desktop"
  depends_on          = [azurerm_virtual_desktop_host_pool.avdhostpool, azurerm_virtual_desktop_workspace.avdworkspace]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.avddag.id
  workspace_id         = azurerm_virtual_desktop_workspace.avdworkspace.id
}