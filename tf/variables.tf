variable "env_name" {
    default = "dev"
    type = string
}

variable "nginx_version" {
    default = "latest"
    type = string
}

variable "nginx_port" {
    default = 4080
    type = number
}

variable "vault_address" {
    default = "http://localhost:8201"
    type = string
}

variable "vault_token" {
    type = string
}

#Service inputs
variable "service_inputs" {
  type = list(object({
    service_name        = string
    service_db_password = string
    service_password    = string
  }))
}