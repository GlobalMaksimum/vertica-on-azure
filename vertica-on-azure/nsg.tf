resource "azurerm_network_security_group" "public_access_nsg" {
  name                = "EnablePublicAccess"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  security_rule {
    name                       = "SSH"
    description                = "ssh access on nodes"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.public_access_source_prefixes
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Vertica"
    description                = "Client access network on vertica"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5433"
    source_address_prefixes    = var.public_access_source_prefixes
    destination_address_prefix = var.vertica_cluster_cidr
  }

  security_rule {
    name                       = "VerticaMC"
    description                = "Client access network for Vertica Management Console"
    priority                   = 1021
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "5450"]
    source_address_prefixes    = var.public_access_source_prefixes
    destination_address_prefix = var.vertica_mc_cidr
  }

  tags = var.tags

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
    destination_port_ranges    = ["4803", "4804", "5434", "50000", "8443"]
    source_address_prefix      = var.vertica_cluster_cidr
    destination_address_prefix = var.vertica_cluster_cidr
  }
  tags = var.tags

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
    destination_port_ranges    = ["5444"]
    source_address_prefixes    = ["10.0.1.0/24", "10.0.2.0/24"]
    destination_address_prefix = "10.0.1.0/24"
  }

  tags = var.tags

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
    destination_port_ranges    = ["4803", "4804", "6543"]
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

  tags = var.tags

}


