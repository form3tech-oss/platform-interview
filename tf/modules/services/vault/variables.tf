variable "VAULT_AUTH_BACKEND" {}

variable "VAULT_GENERIC_SECRET_PATH" {
  type = string
}

variable "VAULT_GENERIC_SECRET_DATA_DB_USER" {
  type = string
}
variable "VAULT_GENERIC_SECRET_DATA_DB_PASSWORD" {
  type = string
}

variable "VAULT_POLICY_NAME" {
  type = string
}

variable "VAULT_POLICY_PATH" {
  type = string
}

variable "VAULT_POLICY_CAPABILITIES" {
  type = list(string)
}

variable "VAULT_GENERIC_ENDPOINT_PATH" {
  type = string
}

variable "VAULT_GENERIC_ENDPOINT_POLICIES" {
  type = string
}

variable "VAULT_GENERIC_ENDPOINT_PASSWORD" {
  type = string
}
