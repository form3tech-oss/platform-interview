variable "IMAGE" {
  type = string
}

variable "NAME" {
  type = string
}

variable "ENV_VARS" {
  type = list(string)
}

variable "NETWORK_NAME" {
  type = string
}

variable "FRONTEND_CONTAINER" {
  default = false
}

variable "FRONTEND_INTERNAL_PORT" {
  default = 0
}

variable "FRONTEND_EXTERNAL_PORT" {
  default = 0
}

