resource "azurerm_resource_group" "app-grp" {
  name     = local.resource_group_name
  location = local.location
}



#resource "azurerm_managed_disk" "appdisk" {
#  name                 = "appdisk"
#  location             = local.location
#  resource_group_name  = local.resource_group_name
#  storage_account_type = "Standard_LRS"
#  create_option        = "Empty"
#  disk_size_gb         = "16"
#}

#resource "azurerm_virtual_machine_data_disk_attachment" "appdiskattach" {
#  managed_disk_id    = azurerm_managed_disk.appdisk.id
#  virtual_machine_id = azurerm_linux_virtual_machine.appvm.id
#  lun                = "0"
#  caching            = "ReadWrite"

#  depends_on = [ azurerm_managed_disk.appdisk ]
#}