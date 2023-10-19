variable "env_name" {
    type = string
}

variable "nginx_version" {
    type = string
}

variable "nginx_port" {
    type = number
}

#Service inputs
variable "services_inputs" {
  type = list(object({
    service_name        = string
    service_db_password = string
    service_password    = string
  }))
}