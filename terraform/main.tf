resource "azurerm_resource_group" "tpot" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "tpot" {
  name                = "vnet-tpot"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.tpot.location
  resource_group_name = azurerm_resource_group.tpot.name
}

resource "azurerm_subnet" "tpot" {
  name                 = "snet-tpot"
  resource_group_name  = azurerm_resource_group.tpot.name
  virtual_network_name = azurerm_virtual_network.tpot.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_security_group" "tpot" {
  name                = "nsg-tpot"
  location            = azurerm_resource_group.tpot.location
  resource_group_name = azurerm_resource_group.tpot.name
}

# Allow SSH/WebUI only from your IP after creation (user should add rules).
# Example rules could be added here via variables if desired.

resource "azurerm_public_ip" "tpot" {
  name                = "pip-tpot"
  location            = azurerm_resource_group.tpot.location
  resource_group_name = azurerm_resource_group.tpot.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "tpot" {
  name                = "nic-tpot"
  location            = azurerm_resource_group.tpot.location
  resource_group_name = azurerm_resource_group.tpot.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.tpot.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tpot.id
  }
}

resource "azurerm_linux_virtual_machine" "tpot" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.tpot.name
  location            = azurerm_resource_group.tpot.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.tpot.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 256
  }
}
