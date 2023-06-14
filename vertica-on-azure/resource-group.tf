resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name

  tags = var.tags

}

resource "azurerm_proximity_placement_group" "ppg_vertica_cluster" {
  name                = "verticaClusterProximityPG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags

}

output "resource_group" {
  value = azurerm_resource_group.rg
}

