# Create storage account for boot diagnostics
resource "random_integer" "account" {
  min = 0
  max = 99999
}


resource "azurerm_storage_account" "vertica_communal" {
  name                     = format("vcommunalstacc%05d", random_integer.account.id)
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  blob_properties {
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = var.tags

  #public_network_access_enabled = false
}

resource "azurerm_storage_account_network_rules" "communal_rules" {
  storage_account_id = azurerm_storage_account.vertica_communal.id
  default_action     = "Allow"
  bypass             = ["Metrics", "Logging", "AzureServices"]


}

resource "azurerm_storage_account" "vertica_datalake" {
  name                     = format("vdatalakestacc%05d", random_integer.account.id)
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  blob_properties {
    delete_retention_policy {
      days = 15
    }

    container_delete_retention_policy {
      days = 30
    }
  }
  tags = var.tags

}

resource "azurerm_storage_account_network_rules" "datalake_rules" {
  storage_account_id = azurerm_storage_account.vertica_datalake.id
  default_action     = "Allow"
  bypass             = ["Metrics", "Logging", "AzureServices"]
}


resource "azurerm_storage_account" "vertica_backup" {
  name                     = format("vbackupstacc%05d", random_integer.account.id)
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  blob_properties {
    container_delete_retention_policy {
      days = 30
    }
  }
  tags = var.tags

}

resource "azurerm_storage_account_network_rules" "backup_rules" {
  storage_account_id = azurerm_storage_account.vertica_backup.id
  default_action     = "Allow"
  bypass             = ["Metrics", "Logging", "AzureServices"]
}

# Storage Containers
resource "azurerm_storage_container" "backup" {
  name                  = "backup"
  storage_account_name  = azurerm_storage_account.vertica_backup.name
  container_access_type = "private"


}

resource "azurerm_storage_container" "datalake" {
  name                  = "datalake"
  storage_account_name  = azurerm_storage_account.vertica_datalake.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "communal" {
  name                  = "communal"
  storage_account_name  = azurerm_storage_account.vertica_communal.name
  container_access_type = "private"
}

# Storage Blob
resource "azurerm_storage_blob" "communal" {
  name                   = "communal"
  storage_account_name   = azurerm_storage_account.vertica_communal.name
  storage_container_name = azurerm_storage_container.communal.name
  type                   = "Block"
  access_tier            = "Hot"


}

resource "azurerm_storage_blob" "backup" {
  name                   = "backup"
  storage_account_name   = azurerm_storage_account.vertica_backup.name
  storage_container_name = azurerm_storage_container.backup.name
  type                   = "Block"
  access_tier            = "Cool"
}

resource "azurerm_storage_blob" "datalake" {
  name                   = "datalake"
  storage_account_name   = azurerm_storage_account.vertica_datalake.name
  storage_container_name = azurerm_storage_container.datalake.name
  type                   = "Block"
  access_tier            = "Cool"
}





output "communal_storage" {
  value = {
    storage_account_name = azurerm_storage_blob.communal.storage_account_name
    url                  = azurerm_storage_blob.communal.url
    primary_access_key   = azurerm_storage_account.vertica_communal.primary_access_key
  }
}
