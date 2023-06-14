resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_proximity_placement_group" "ppg_vertica_cluster" {
  name                = "verticaClusterProximityPG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

output "resource_group" {
  value = azurerm_resource_group.rg
}

