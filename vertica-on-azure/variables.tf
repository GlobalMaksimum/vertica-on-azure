
variable "vm_prefix" {
  description = "VM name prefix for vertica instances"
}

variable "node_count" {
  description = "Number of nodes on cluster"
  type        = number

}

variable "virtual_network_cidr"{
  default = "10.0.0.0/16"
  description = "Counterpart of VPC in AWS. Defines a complete new network"
}

variable "vertica_cluster_cidr" {
  default = "10.0.1.0/24"
}

variable "vertica_mc_cidr" {
  default = "10.0.2.0/24"
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

variable "ansible_directory" {
  default     = "ansible"
  description = "Output directory for ansible template generation"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A set of tags to used with resources"
}

variable "public_access_source_prefixes"{
  type = list(string)
  default = [ "0.0.0.0/0" ]
  description = "CIDR or * from which public access will be initiated"
}