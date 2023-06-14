
variable "vm_prefix" {
  description = "VM name prefix for vertica instances"
}

variable "node_count" {
  description = "Number of nodes on cluster"
  type        = number

}

variable "vertica_cidr" {
  default = "10.70.2.0/24"
}

variable "subscription_id" {
  description = "Azure Subscription Id"
}

variable "tenant_id" {
  description = "Azure Tenant Id"
}

variable "client_id" {
  description = "Azure Client/App Id"
}

variable "client_secret" {
  description = "Azure Client Secret/password"

}

variable "resource_group_name" {
  description = "Azure resource group name"
}

variable "resource_group_location" {
  description = "Azure resource group location"
  default     = "westeu"
}


variable "admin_username" {
  default = "gmadmin"
}
variable "admin_password" {
  default = "ms123!"

}

variable "network_name" {
  description = "Azure network name"
}

variable "tags" {
  type        = list(string)
  description = "Tags for faster resource search"
}

variable "vertica_vm_size" {
  description = "Azure VM instance type for Vertica VMs (Not that not all types are suitable for vertica deployment)"
  default     = "Standard_DS1_v2"

}

variable "domain" {
  description = "Server domain for fqdn"

}

variable "ansible_inventory_file" {
  default     = "inventory"
  description = "Name of the inventory file for ansible generated"

}

variable "admin_user" {
  default     = "gmadmin"
  description = "VM OS level admin user"
}

variable "ansible_directory"{
  default = "ansible"
  description = "Output directory for ansible template generation"
}