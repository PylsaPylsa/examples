resource "azurerm_virtual_network" "vnet-tf-main" {
  name                = "vnet-${var.tfResourcePrefix}main"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet {
    name           = "SubnetProd"
    address_prefix = "10.0.0.0/24"
  }
  subnet {
    name           = "SubnetAcc"
    address_prefix = "10.0.64.0/24"
  }
  subnet {
    name           = "SubnetTest"
    address_prefix = "10.0.128.0/24"
  }
  subnet {
    name           = "SubnetDev"
    address_prefix = "10.0.192.0/24"
  }
}