resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  dynamic security_rule{
    for_each = local.networksecuritygroup_rules
    content {
      name="Allow-${security_rule.value.destination_port_range}"
      priority=security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  depends_on = [ azurerm_resource_group.app-grp ]
}

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  count=var.number_of_subnets
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.appnsg.id
  depends_on = [
    azurerm_virtual_network.appnetwork,
    azurerm_network_security_group.appnsg
   ]
}

resource "azurerm_virtual_network" "appnetwork" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]

  depends_on = [ azurerm_resource_group.app-grp ]
}

resource "azurerm_subnet" "subnets" {
  count = var.number_of_subnets
  name                 = "Subnet${count.index}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
  depends_on = [ azurerm_virtual_network.appnetwork ]
}
