variable "env_name" {
    type = string
}

variable "service_image" {
    type = string
}

variable "service_name" {
    type = string
}

variable "service_db_password" {
    type = string
}

variable "service_password" {
    type = string
}

variable "vault_auth_backend_userpass" {
    type = any
}