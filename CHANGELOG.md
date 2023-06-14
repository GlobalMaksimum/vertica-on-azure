### 2023.06.14 - Commit 2

* Add `telnet` package to all nodes (required for connectivity tests)
* Add `.gitignore`
* Prevent vertica rpm installation on Vertica MC nodes. Define a new `vertica_mc_inventory_group` to be used in `vertica` role.
  * Prevent TZ link on mc node
* Add template genetation of following variables in Ansible inventory by Terraform
  * `communal_storage_account_name`
  * `communal_storage_access_key`
* Add Azure tags on terraform resources
* Create following terraform network variables for flexibility
  * `virtual_network_cidr` - Network CIDR
    * `vertica_cluster_cidr` - Subnet CIDR under `virtual_network_cidr` got Vertica cluster nodes
    * `vertica_mc_cidr` - Subnet CIDR under `virtual_network_cidr` for Vertica MC installation
    * `public_access_source_prefixes` - List of CIDR for SSH, Vertica MC and Vertica client access
