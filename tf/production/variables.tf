variable "account_service" {
  type = object({
    db_user           = string
    db_password       = string
    endpoint_password = string
    docker_image      = string
  })
  sensitive = true
}

variable "gateway_service" {
  type = object({
    db_user           = string
    db_password       = string
    endpoint_password = string
    docker_image      = string
  })
  sensitive = true
}

variable "payment_service" {
  type = object({
    db_user           = string
    db_password       = string
    endpoint_password = string
    docker_image      = string
  })
  sensitive = true
}

variable "environment" {
  type = string
}

variable "vault_token" {
  type = string
}
