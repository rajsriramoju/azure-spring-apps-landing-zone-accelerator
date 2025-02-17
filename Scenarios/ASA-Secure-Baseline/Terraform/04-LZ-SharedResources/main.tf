
data "terraform_remote_state" "lz-network" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_sa_name
    container_name       = var.state_sa_container_name
    key                  = "lz-network"
    resource_group_name  = var.state_sa_rg
  }
}


resource "random_string" "random" {
  length = 4
  upper = false
  special = false
}

#Random password for Jump Host
resource "random_password" "jumphostpass" {
  length = 15
  upper = true
  special = true  
}


locals  {
  # # Hub Data can be read from existing state file or local variables
  # hub_vnet_name            = ( var.Hub_Vnet_Name == "" ? data.terraform_remote_state.lz-network.outputs.hub_vnet_name : var.Hub_Vnet_Name )     
  # hub_rg                   = ( var.Hub_Vnet_RG   == "" ? data.terraform_remote_state.lz-network.outputs.hub_rg : var.Hub_Vnet_RG )
  # hub_subscriptionId       = ( var.Hub_Vnet_Subscription == "" ? data.terraform_remote_state.lz-network.outputs.hub_subscriptionId  : var.Hub_Vnet_Subscription )

  shared_rg                = "rg-${var.name_prefix}-SHARED"

  spoke_rg                 = data.terraform_remote_state.lz-network.outputs.spoke_rg
  spoke_vnet_name          = data.terraform_remote_state.lz-network.outputs.spoke_vnet_name
  subnet_shared_name       = var.shared-subnet-name
  subnet_cloudsupport_name = var.springboot-support-subnet-name

  private_dns_rg           = data.terraform_remote_state.lz-network.outputs.private_dns_rg

  jumphost_name            = substr("vm${var.name_prefix}${var.environment}",0,14)
  jumphost_user            = var.jump_host_admin_username

  # If a jumphost_pass was provided, then use that, otherwise, use a random password.
  jumphost_pass            = ( var.jump_host_password == "" ? random_password.jumphostpass.result : var.jump_host_password )
  password_notice          = ( var.jump_host_password == "" ? "To get access to the VM, use the Reset Password feature in the Azure Portal.\nAzure Portal > VM > Reset Password" : "A custom password was provided.  To reset go to Azure Portal > VM > Reset Password" )
}

# Get info about the current azurerm context
data "azurerm_client_config" "current" {}

# Get info about the existing Spoke VNET and subnets
data "azurerm_virtual_network" "spoke_vnet" {
  name                = local.spoke_vnet_name
  resource_group_name = local.spoke_rg
}

data "azurerm_subnet" "snetsharedsubnet" {
  name                 =  local.subnet_shared_name
  virtual_network_name =  local.spoke_vnet_name
  resource_group_name  =  local.spoke_rg
}

data "azurerm_subnet" "azuresbcloudsupport" {
  name                 =  local.subnet_cloudsupport_name
  virtual_network_name =  local.spoke_vnet_name
  resource_group_name  =  local.spoke_rg
}


# Get info about Private DNS Zones
data "azurerm_private_dns_zone" "keyvault_zone" {
  name                 =  var.keyvault_dnszone_name
  resource_group_name  =  local.private_dns_rg
}





# Create the Shared Resource group 
resource "azurerm_resource_group" "shared_rg" {
    name                        = local.shared_rg
    location                    = var.location
}



