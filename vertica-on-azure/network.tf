resource "azurerm_virtual_network" "analytics_network" {
  name                = var.network_name
  address_space       = [var.virtual_network_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags

}

resource "azurerm_subnet" "vertica_cluster_subnet" {
  name                 = "vertica_cluster_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.analytics_network.name
  address_prefixes     = [var.vertica_cluster_cidr]

}

resource "azurerm_subnet" "management_subnet" {
  name                 = "management_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.analytics_network.name
  address_prefixes     = [var.vertica_mc_cidr]
}

# resource "azurerm_subnet" "bastion_subnet" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.analytics_network.name
#   address_prefixes     = ["10.0.3.0/24"]
# }

resource "azurerm_network_interface" "vertica_cluster_network_interface" {
  count               = var.node_count
  name                = "${var.vm_prefix}_ni${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "verticaConfiguration"
    subnet_id                     = azurerm_subnet.vertica_cluster_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags

}

resource "azurerm_network_interface_security_group_association" "vertica_cluster_nsg" {
  count                     = var.node_count
  network_interface_id      = azurerm_network_interface.vertica_cluster_network_interface[count.index].id
  network_security_group_id = azurerm_network_security_group.public_access_nsg.id


}

resource "azurerm_network_interface" "vertica_management_interface" {
  name                = "${var.vm_prefix}_management_ni"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "verticaManagementConfiguration"
    subnet_id                     = azurerm_subnet.management_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mc_ip.id
  }

  tags = var.tags

}

resource "azurerm_network_interface_security_group_association" "vertica_mc_nsg" {
  network_interface_id      = azurerm_network_interface.vertica_management_interface.id
  network_security_group_id = azurerm_network_security_group.public_access_nsg.id
}

output "mc_public_ip" {
  value = azurerm_network_interface.vertica_management_interface.ip_configuration
}