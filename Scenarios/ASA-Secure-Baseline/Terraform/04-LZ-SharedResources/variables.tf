##################################################
### Shared Resources variables
##################################################

variable "name_prefix" {
    type= string
    description = "This prefix will be used when naming resources. 10 characters max."
    validation {
      condition = length(var.name_prefix)<=10
      error_message = "name_prefix: 10 characters max allowed."
    }
}

variable "location" {
    type = string    
    description = "Deployment region (ex. East US), for supported regions see https://docs.microsoft.com/en-us/azure/spring-apps/faq?pivots=programming-language-java#in-which-regions-is-azure-spring-apps-basicstandard-tier-available"
}

variable "environment" {
    type = string    
    description = "Deployment environment, example: dev,prod,stg etc."
} 


variable "tags" {
    type        = map 
    default     = { 
        project = "ASA-Accelerator"
    }
}


# Info about Precreated Hub and Spoke VNETS

variable "Hub_Vnet_Name" {
    type = string    
    description = "The name of the Hub Vnet.  Leave empty and will be read from state files"
    default =""
} 

variable "Hub_Vnet_RG" {
    type = string    
    description = "The name of the Hub RG.  Leave empty and will be read from state files"
    default =""
}

variable "Hub_Vnet_Subscription" {
    type = string    
    description = "The Subscription for the Hub VNET.  Leave empty and will be read from state files"
    default =""
}

variable "Bring_Your_Own_Hub" {
    type = bool   
    description = "Set to true if using your own Hub - the plan will not make modifications related to the Hub"
    default = false
}

# Subnets Info

# Spoke Subnets - use the TFVars file if you want to modify these

variable "shared-subnet-name" {
    type        = string
    description = "Shared Services Subnet Name"
    default     = "snet-shared"
}

variable "springboot-support-subnet-name" {
    type        = string
    description = "Spring Apps Private Link Subnet Name"
    default     = "snet-support"
}

# Jump host module
variable "jump_host_private_ip_addr" {
    type        = string 
    description = "Azure Jump Host Address"
    default     = "10.1.4.5"
}
variable "jump_host_vm_size" {
    type        = string 
    description = "Azure Jump Host VM SKU"
    default     = "Standard_DS3_v2"
}
variable "jump_host_admin_username" {
    type        = string 
    description = "Admin Username, used by Jump Host"
    default     = "lzadmin"
}

# The password for the Jump Host Admin account
variable "jump_host_password" {
    sensitive   = true
    type        = string
    description = "Admin Password, used by Jump Host"
    default     = ""
}

# For Azure KeyVault
variable "keyvault_dnszone_name" {
    type = string
    description = "The Azure KeyVault Private DNS Zone name"
    default = "privatelink.vaultcore.azure.net"
}

# This variable definition is used by other related plans
# We add it here simply to avoid warnings from terraform
# About being included in the parameters file.
variable SRINGAPPS_SPN_OBJECT_ID {
    type = string
    default = "notused"
}



## This is required for retrieving state
variable "state_sa_name" {}

variable "state_sa_container_name" {}

# Storage Account Resource Group
variable "state_sa_rg" {}

