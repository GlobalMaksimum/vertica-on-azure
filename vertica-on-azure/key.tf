resource "tls_private_key" "login_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.login_ssh.private_key_pem
  filename        = "${var.ansible_directory}/.ssh/az_gmadmin"
  file_permission = "0600"
}