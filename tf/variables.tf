variable "prefix" { 
  description = "This is the prefix for the environment. Explamples: dev, prod, staging"
} 

variable "environment" { 
  description = "Full environment name. Examples: development, staging. production"
} 

variable "vault_port" { 
  description = "Listening port for vault"
} 

variable "vault_token" { 
  description = "Token value to connect to vault"
}

variable "vault_internal_addr" { 
  description = "Internal vault URL address"
}

variable "vault_account_db_user" {
  description = "db_user for account vault db"
} 
variable "vault_account_db_password" {
  description = "db_password for account vault db"
} 

variable "vault_gateway_db_user" {
  description = "db_user for gateway vault db"
}
variable "vault_gateway_db_password" {
  description = "db_password for gateway vault db"
}
variable "vault_payment_db_user" {
  description = "db_user for paymentt vault db"
}
variable "vault_payment_db_password" {
  description = "db_password for payment vault db"
}

variable "vault_account_ep_username" { 
  description = "vault endpoint account username"
}
variable "vault_account_ep_password" { 
  description = "vault endpoint account passowrd"
}
variable "vault_gateway_ep_username" {
  description = "vault endpoint gateway username"
}
variable "vault_gateway_ep_password" {
  description = "vault endpoint gateway passowrd"
}
variable "vault_payment_ep_username" {
  description = "vault endpoint payment username"
}
variable "vault_payment_ep_password" {
  description = "vault endpoint payment passowrd"
}

variable "vault_policy_account_name" { 
  description = "resouce vault_policy.account name"
}
variable "vault_policy_gateway_name" {
  description = "resouce vault_policy.gateway name"
}
variable "vault_policy_payment_name" { 
  description = "resouce vault_policy.payment name"
} 

variable "service_name_account" {
  description = "Serice account name"
} 
variable "service_name_gateway" { 
  description = "Serice gateway name"
} 
variable "service_name_payment" {
  description = "Serice payment name"
}
variable "network_name" { 
  description = "Network name"
}

variable "environment_path" {
  description = "path name as part of environment"
}
