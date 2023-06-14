resource "azurerm_network_security_group" "ssh_nsg" {
  name                = "EnableSSHLogin"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "mc_nsg" {
  name                = "EnableManagementConsoleAccess"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "MC"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443","5450"]
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }
}

resource "azurerm_network_security_group" "vertica_cluster_tcp_nsg" {
  name                = "VerticaClusterTCP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "MC"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["4803","4804","5434","50000","8443"]
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_network_security_group" "vertica_mc2node_tcp_nsg" {
  name                = "VerticaMC2NodeAndNode2Node"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "MC"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["5444"]
    source_address_prefixes = ["10.0.1.0/24","10.0.2.0/24"]
    destination_address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_network_security_group" "vertica_client_tcp_nsg" {
  name                = "VerticaClientTCP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "VerticaClientAccess"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["5433"]
    source_address_prefixes = ["10.0.1.0/24","10.0.2.0/24"]
    destination_address_prefix = "10.0.1.0/24"
  }
}


resource "azurerm_network_security_group" "vertica_cluster_udp_nsg" {
  name                = "VerticaClusterUDP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "MC"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_ranges     = ["4803","4804","6543"]
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }
}


