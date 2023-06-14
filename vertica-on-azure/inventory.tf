resource "local_file" "AnsibleInventory" {
  content = templatefile("${path.module}/inventory.j2",
    {
      vertica_vm = azurerm_linux_virtual_machine.vertica,
      mc_vm      = azurerm_linux_virtual_machine.vertica_mc,
      domain     = var.domain
      user = {
        uid = 2000
        gid = 2000
      }
      ansible_directory = var.ansible_directory
    }
  )
  filename = "${var.ansible_directory}/${var.ansible_inventory_file}" 
}


resource "local_file" "AnsibleConfiguration" {
  content = templatefile("${path.module}/ansible.cfg.j2",
    {
      ansible_inventory_file = var.ansible_inventory_file
      admin_user             = var.admin_user
      ansible_directory = var.ansible_directory
    }
  )
  filename = "${var.ansible_directory}/ansible.cfg"
}
