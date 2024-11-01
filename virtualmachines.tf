resource "azurerm_network_interface" "appinterface" {
  count               = var.number_of_subnets
  name                = "appinterface${count.index}-nic"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal${count.index}"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id
  }

  depends_on = [ 
    azurerm_subnet.subnets,
    azurerm_public_ip.appip
 ]
}

resource "azurerm_public_ip" "appip" {
  name                = "app-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.app-grp ]
}

output "azurerm_public_ip" {
  value=azurerm_public_ip.appip.ip_address
}

resource "azurerm_linux_virtual_machine" "appvm" {
  count = var.number_of_subnets
  name                = "appvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.appinterface[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.azureuser_ssh.public_key_openssh 
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = var.os_offer
    sku       = var.os_sku
    version   = "latest"
  }

  depends_on = [
    azurerm_resource_group.app-grp,
    azurerm_network_interface.appinterface,
    tls_private_key.azureuser_ssh ]
}

resource "null_resource" "installnginx" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
    ]
    
    connection {
      type = "ssh"
      user = "${var.admin_username}"
      private_key = file("${local_file.ssh_privat_key.filename}")
      host = "${azurerm_public_ip.appip.ip_address}"
    }
  }
  depends_on = [ azurerm_linux_virtual_machine.appvm ]
}

output "ssh_command" {
  value="ssh -i ${local_file.ssh_privat_key.filename} ${var.admin_username}@${azurerm_public_ip.appip.ip_address} -o StrictHostKeyChecking=no -o IdentitiesOnly=yes"
  #value="ssh -i ${local_file.ssh_privat_key.filename} ${var.admin_username}@$ip_address -o StrictHostKeyChecking=no -o IdentitiesOnly=yes"
}

#output "ssh_command" {
#  value = {
#    for ip in azurerm_public_ip.appip.*.ip_address : k => jsondecode(v.body)["id"]
#  }
#}