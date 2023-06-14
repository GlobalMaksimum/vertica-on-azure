# resource "azurerm_public_ip" "bastion_ip" {
#   name                = "bastion_ip"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bastion_host" {
#   name                = "analytics-bastion"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   shareable_link_enabled = true
#   sku = "Standard"

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.bastion_subnet.id
#     public_ip_address_id = azurerm_public_ip.bastion_ip.id
#   }
# }