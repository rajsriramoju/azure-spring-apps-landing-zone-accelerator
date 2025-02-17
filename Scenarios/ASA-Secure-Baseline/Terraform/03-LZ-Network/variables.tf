##################################################
### Network Spoke Variables
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

variable "SRINGAPPS_SPN_OBJECT_ID" {
    type = string
    description = "Specify the Object ID for the Azure Spring Apps Service principal in the customer's Azure AD Tenant. Use this command to obtain: az ad sp show --id e8de9221-a19c-4c81-b814-fd37c6caf9d2 --query id --output tsv"
} 


variable "tags" {
    type        = map 
    default     = { 
        project = "ASA-Accelerator"
    }
}

# Spoke VNET
variable "spoke_vnet_addr_prefix" {
    type        = string 
    description = "Spoke VNET prefix"
    default     = "10.1.0.0/16"
}

# Spoke Subnets - use the TFVars file if you want to modify these
variable "springboot-service-subnet-name" {
    type        = string
    description = "Spring Apps Service Subnet"
    default     = "snet-runtime"
}

variable "springboot-service-subnet-addr" {
    type        = string
    description = "Spring Apps CIDR Subnet"
    default     = "10.1.0.0/24"
}

variable "springboot-apps-subnet-name" {
    type        = string
    description = "Spring Apps Service Subnet"
    default     = "snet-app"
}

variable "springboot-apps-subnet-addr" {
    type        = string
    description = "Spring Apps Apps CIDR Subnet"
    default     = "10.1.1.0/24"
}

variable "springboot-support-subnet-name" {
    type        = string
    description = "Spring Apps Private Link Subnet Name"
    default     = "snet-support"
}

variable "springboot-support-subnet-addr" {
    type        = string
    description = "Spring Apps Private Link Subnet"
    default     = "10.1.2.0/24"
}

variable "shared-subnet-name" {
    type        = string
    description = "Shared Services Subnet Name"
    default     = "snet-shared"
}

variable "shared-subnet-addr" {
    type        = string
    description = "Shared Services Subnet Address Range"
    default     = "10.1.4.0/24"
}

variable "appgw-subnet-name" {
    type        = string
    description = "App Gateway Subnet Name"
    default     = "snet-agw"
}

variable "appgw-subnet-addr" {
    type        = string
    description = "App Gateway Subnet Address"
    default     = "10.1.5.0/24"
}

variable "springapps_dnszone_name" {
    type = string
    description = "The SpringApps Private DNS Zone name"
    default = "private.azuremicroservices.io"
}

variable "keyvault_dnszone_name" {
    type = string
    description = "The Azure KeyVault Private DNS Zone name"
    default = "privatelink.vaultcore.azure.net"
}

## Needed for the Peering
variable "Hub_Vnet_Name" {
    type = string    
    description = "The name of the Hub Vnet. Only specify if using bringing your own Hub"
    default =""
} 

variable "Hub_Vnet_RG" {
    type = string    
    description = "The name of the Hub RG. Only specify if using bringing your own Hub"
    default =""
}

variable "Hub_Vnet_Subscription" {
    type = string    
    description = "The Subscription for the Hub VNET.  Leave empty if the same as Spoke Subscription"
    default =""
}

variable "Bring_Your_Own_Hub" {
    type = bool   
    description = "Set to true if using your own Hub - the plan will not make modifications related to the Hub"
    default = false
}

## This is required for retrieving state
variable "state_sa_name" {}

variable "state_sa_container_name" {}

# Storage Account Resource Group
variable "state_sa_rg" {}





