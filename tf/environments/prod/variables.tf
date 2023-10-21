#Service inputs
variable "environment_inputs" {
  type = object({
    env_name = string
    nginx_port = number
    nginx_version = string
    vault_address = string
    vault_token = string
  })
}

#Service inputs
variable "services_inputs" {
  type = list(object({
    service_name        = string
    service_db_password = string
    service_password    = string
  }))
}