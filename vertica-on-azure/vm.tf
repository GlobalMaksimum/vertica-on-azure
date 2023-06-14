

# resource "azurerm_managed_disk" "test" {
#   count                = 2
#   name                 = "datadisk_existing_${count.index}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "1024"
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "test" {
#   count              = 2
#   managed_disk_id    = azurerm_managed_disk.test[count.index].id
#   virtual_machine_id = azurerm_linux_virtual_machine.test[count.index].id
#   lun                = "10"
#   caching            = "ReadWrite"
# }

resource "azurerm_linux_virtual_machine" "vertica" {
  count                        = var.node_count
  name                         = format("${var.vm_prefix}%03d", count.index + 1)
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  size                         = var.vertica_vm_size
  proximity_placement_group_id = azurerm_proximity_placement_group.ppg_vertica_cluster.id
  network_interface_ids        = [azurerm_network_interface.vertica_cluster_network_interface[count.index].id]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  #delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  #delete_data_disks_on_termination = true

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = format("${var.vm_prefix}_os_disk%03d", count.index + 1)
  }

  computer_name  = format("${var.vm_prefix}%03d", count.index + 1)
  admin_username = var.admin_username

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.login_ssh.public_key_openssh
  }

  tags = var.tags


}

resource "azurerm_managed_disk" "vertica_catalog" {
  count                = var.node_count
  name                 = format("${var.vm_prefix}%03d-catalog", count.index + 1)
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 50

  tags = var.tags

}

resource "azurerm_managed_disk" "vertica_opt" {
  count                = var.node_count
  name                 = format("${var.vm_prefix}%03d-opt", count.index + 1)
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10

  tags = var.tags

}


resource "azurerm_virtual_machine_data_disk_attachment" "attach_catalog" {
  count              = var.node_count
  managed_disk_id    = azurerm_managed_disk.vertica_catalog[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.vertica[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}


resource "azurerm_virtual_machine_data_disk_attachment" "attach_opt" {
  count              = var.node_count
  managed_disk_id    = azurerm_managed_disk.vertica_opt[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.vertica[count.index].id
  lun                = "20"
  caching            = "ReadWrite"
}

# resource "azurerm_managed_disk" "test" {
#   count                = 2
#   name                 = "datadisk_existing_${count.index}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "1024"
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "test" {
#   count              = 2
#   managed_disk_id    = azurerm_managed_disk.test[count.index].id
#   virtual_machine_id = azurerm_linux_virtual_machine.test[count.index].id
#   lun                = "10"
#   caching            = "ReadWrite"
# }


