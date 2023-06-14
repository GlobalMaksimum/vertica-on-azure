resource "azurerm_public_ip" "mc_ip" {
  name                = "mc_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}


resource "azurerm_linux_virtual_machine" "vertica_mc" {
  name                  = "${var.vm_prefix}_management"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.vertica_management_interface.id]

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "vertica_mc_os_disk"
  }

  computer_name  = "${var.vm_prefix}-mc"
  admin_username = var.admin_username
  #admin_password                  = var.admin_password
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.login_ssh.public_key_openssh
  }
}

resource "azurerm_managed_disk" "mc_opt" {
  name                 = "${var.vm_prefix}-mc-opt"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach_mc_opt" {
  managed_disk_id    = azurerm_managed_disk.mc_opt.id
  virtual_machine_id = azurerm_linux_virtual_machine.vertica_mc.id
  lun                = "20"
  caching            = "ReadWrite"
}