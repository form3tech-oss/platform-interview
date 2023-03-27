variable "environment" {
  type = string
}

variable "service" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "endpoint_password" {
  type = string
}

variable "vault_addr" {
  type    = string
  default = ""
}

variable "vault_username" {
  type    = string
  default = ""
}
