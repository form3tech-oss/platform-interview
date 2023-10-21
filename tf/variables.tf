#Environment inputs
variable "environment_inputs_dev" {
  type = object({
    env_name = string
    nginx_port = number
    nginx_version = string
    vault_address = string
    vault_token = string
  })
}

#Service inputs
variable "services_inputs_dev" {
  type = list(object({
    service_name        = string
    service_db_password = string
    service_password    = string
  }))
}


#Prod environment inputs
variable "environment_inputs_prod" {
  type = object({
    env_name = string
    nginx_port = number
    nginx_version = string
    vault_address = string
    vault_token = string
  })
}

#Prod service inputs
variable "services_inputs_prod" {
  type = list(object({
    service_name        = string
    service_db_password = string
    service_password    = string
  }))
}


#Stage environment inputs
variable "environment_inputs_stage" {
  type = object({
    env_name = string
    nginx_port = number
    nginx_version = string
    vault_address = string
    vault_token = string
  })
}

#Stage service inputs
variable "services_inputs_stage" {
  type = list(object({
    service_name        = string
    service_db_password = string
    service_password    = string
  }))
}