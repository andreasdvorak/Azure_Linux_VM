resource "tls_private_key" "azureuser_ssh" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "ssh_privat_key" {
  filename = ".ssh/privat_key.pem"
  file_permission = "0600"
  content = tls_private_key.azureuser_ssh.private_key_pem
  depends_on = [ tls_private_key.azureuser_ssh ]
}

resource "local_file" "ssh_public_key" {
  filename = ".ssh/public_key.pem"
  file_permission = "0600"
  content = tls_private_key.azureuser_ssh.public_key_pem
  depends_on = [ tls_private_key.azureuser_ssh ]
}