# Create Resource Group we're using
resource "azurerm_resource_group" "main" {
  name     = "tf-rg-main"
  location = "West Europe"
}

# Create the main vnet
resource "azurerm_virtual_network" "main" {
  name                = "tf-vnet-main"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create a subnet for our main vnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a public IP address for the web server
resource "azurerm_public_ip" "web01" {
  name                = "tf-pip-web01"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# Create a network interface for the web server and associate the public IP address
resource "azurerm_network_interface" "web01" {
  name                = "tf-nic-vm-web01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.150"
    public_ip_address_id          = azurerm_public_ip.web01.id
  }
}

# Create the web server itself and associate the correct network interface
resource "azurerm_windows_virtual_machine" "web01" {
  name                = "tf-vm-web01"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2as_v5"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd12345!" # Make sure to replace this! :)
  network_interface_ids = [
    azurerm_network_interface.web01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
