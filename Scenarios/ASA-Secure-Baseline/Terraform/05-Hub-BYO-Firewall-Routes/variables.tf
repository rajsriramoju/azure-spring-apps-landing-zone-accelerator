##################################################
### BYO Firewall variables
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


# Info about Precreated Hub 
#variable "Hub_Vnet_Name" {
#   type = string    
#    description = "The name of the Hub Vnet"
#    default =""
#} 
#
variable "Hub_Vnet_RG" {
    type = string    
    description = "The name of the Hub RG"
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


# Subnets Info
# Spoke Subnets - use the TFVars file if you want to modify these
variable "springboot-service-subnet-name" {
    type        = string
    description = "Spring Apps Service Subnet"
    default     = "snet-runtime"
}

variable "springboot-apps-subnet-name" {
    type        = string
    description = "Spring Apps Service Subnet"
    default     = "snet-app"
}

variable "springboot-data-subnet-name" {
    type        = string
    description = "Spring Apps Data Services Subnet"
    default     = "snet-data"
}

variable "springboot-support-subnet-name" {
    type        = string
    description = "Spring Apps Private Link Subnet Name"
    default     = "snet-support"
}

variable "shared-subnet-name" {
    type        = string
    description = "Shared Services Subnet Name"
    default     = "snet-shared"
}


## This is required for retrieving state
variable "state_sa_name" {}

variable "state_sa_container_name" {}

# Storage Account Resource Group
variable "state_sa_rg" {}


# BYO FW IP address
variable "FW_IP" {}