variable "environment" {
  type = string
}

variable "account_service_credentials" {
  type = object({
    db_user           = string
    db_password       = string
    endpoint_password = string
  })
  sensitive = true
}



variable "gateway_service_credentials" {
  type = object({
    db_user           = string
    db_password       = string
    endpoint_password = string
  })
  sensitive = true
}

variable "payment_service_credentials" {
  type = object({
    db_user           = string
    db_password       = string
    endpoint_password = string
  })
  sensitive = true
}

variable "account_service_docker_image" {
  type = string
}

variable "gateway_service_docker_image" {
  type = string
}

variable "payment_service_docker_image" {
  type = string
}

variable "vault_token" {
  type      = string
  sensitive = true
}
