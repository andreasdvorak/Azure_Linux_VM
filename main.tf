resource "azurerm_resource_group" "app-grp" {
  name     = local.resource_group_name
  location = local.location
}
