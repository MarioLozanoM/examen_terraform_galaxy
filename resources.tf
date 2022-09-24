resource "azurerm_resource_group" "examen_rg" {
  name     = "${var.prefix}rg"
  location = var.location

  tags = {
    environment = "examen"
  }
}

resource "azurerm_virtual_network" "examen_vnet" {
  name                = "${var.prefix}vnet"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.examen_rg.location
  resource_group_name = azurerm_resource_group.examen_rg.name

  tags = {
    environment = "examen"
  }
}

resource "azurerm_subnet" "examen_int" {
  name                 = "${var.prefix}int"
  resource_group_name  = azurerm_resource_group.examen_rg.name
  virtual_network_name = azurerm_virtual_network.examen_vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  depends_on = [
    azurerm_virtual_network.examen_vnet
  ]
}

resource "azurerm_public_ip" "examen_pip" {
  name                = "${var.prefix}pip"
  location            = azurerm_resource_group.examen_rg.location
  resource_group_name = azurerm_resource_group.examen_rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "examen"
  }
}

resource "azurerm_network_interface" "examen_nic" {
  name                = "${var.prefix}nic"
  location            = azurerm_resource_group.examen_rg.location
  resource_group_name = azurerm_resource_group.examen_rg.name

  ip_configuration {
    name                          = "examen_ip_config"
    subnet_id                     = azurerm_subnet.examen_int.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.examen_pip.id
  }

  tags = {
    environment = "examen"
  }
}


resource "azurerm_network_security_group" "examen_nsg" {
  name                = "${var.prefix}nsg"
  location            = azurerm_resource_group.examen_rg.location
  resource_group_name = azurerm_resource_group.examen_rg.name

  security_rule {
    name                       = "examen_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "examen"
  }
}

resource "azurerm_network_interface_security_group_association" "examen_sg_asc" {
  network_interface_id      = azurerm_network_interface.examen_nic.id
  network_security_group_id = azurerm_network_security_group.examen_nsg.id
}

resource "azurerm_windows_virtual_machine" "examen_vm" {
  name                  = "${var.prefix}vm"
  location              = azurerm_resource_group.examen_rg.location
  resource_group_name   = azurerm_resource_group.examen_rg.name
  network_interface_ids = [azurerm_network_interface.examen_nic.id]
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  computer_name         = "${var.prefix}pc"

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

  tags = {
    environment = "examen"
  }
}
