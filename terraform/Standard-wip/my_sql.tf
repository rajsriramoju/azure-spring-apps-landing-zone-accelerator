resource "azurerm_private_dns_zone" "mysql_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.sc_corp_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "ms-hub-link" {
  name                  = "mysql-zone-hub-link"
  resource_group_name   = azurerm_resource_group.sc_corp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql_zone.name
  virtual_network_id    = azurerm_virtual_network.hub.id 
}

resource "azurerm_private_dns_zone_virtual_network_link" "ms-spoke-link" {
  name                  = "mysql-zone-spoke-link"
  resource_group_name   = azurerm_resource_group.sc_corp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql_zone.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

# NSG for MySQL subnet

resource "azurerm_network_security_group" "mysql_svc_nsg" { 
    name                        = "data-service-nsg"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.sc_corp_rg.name
}

resource "azurerm_subnet_network_security_group_association" "data_service_nsg_assoc" {
  subnet_id                 = azurerm_subnet.azuresbcloudapps.id
  network_security_group_id = azurerm_network_security_group.mysql_svc_nsg.id
}


resource "azurerm_mysql_server" "mysql" {
  name                = "${var.mysql_server_name_prefix}-${random_string.random.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.sc_corp_rg.name

  administrator_login          = var.my_sql_admin
  administrator_login_password = var.my_sql_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 51200
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = false
  #ssl_minimal_tls_version_enforced  = "TLS1_2"

  timeouts {
      create = "60m"
      delete = "2h"
  }
}

resource "azurerm_private_endpoint" "mysql-endpoint" {
  name                = "mysql-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.sc_corp_rg.name
  subnet_id           = azurerm_subnet.azuresbcloudapps.id

  private_service_connection {
    name                           = "mysql-private-link-connection"
    private_connection_resource_id = azurerm_mysql_server.mysql.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }

  private_dns_zone_group {
    name                          = azurerm_private_dns_zone.mysql_zone.name
    private_dns_zone_ids          = [ azurerm_private_dns_zone.mysql_zone.id ]
  }

  timeouts {
      create = "60m"
      delete = "2h"
  }
}

