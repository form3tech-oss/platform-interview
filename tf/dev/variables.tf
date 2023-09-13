variable "token" {
  type        = string
  default     = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
  description = "dev token"
}

variable "vault_services_vars" {
  type = list(object({
    secret_path                   = string
    secret_data_json              = string
    policy_name                   = string
    policy                        = string
    endpoint_path                 = string
    endpoint_ignore_absent_fields = bool
    endpoint_data_json            = string
  }))
  default = [
    {

      secret_path                   = "secret/development/account"
      secret_data_json              = <<EOT
{
  "db_user":   "account",
  "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
}
EOT
      policy_name                   = "account_development"
      policy                        = <<EOT

path "secret/data/development/account" {
    capabilities = ["list", "read"]
}

EOT
      endpoint_path                 = "auth/userpass/users/account-development"
      endpoint_ignore_absent_fields = true
      endpoint_data_json            = <<EOT
{
  "policies": ["account-development"],
  "password": "123-account-development"
}
EOT
    },
    {

      secret_path                   = "secret/development/gateway"
      secret_data_json              = <<EOT
{
  "db_user":   "gateway",
  "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
}
EOT
      policy_name                   = "gateway_development"
      policy                        = <<EOT

path "secret/data/development/gateway" {
    capabilities = ["list", "read"]
}

EOT
      endpoint_path                 = "auth/userpass/users/gateway-development"
      endpoint_ignore_absent_fields = true
      endpoint_data_json            = <<EOT
{
  "policies": ["gateway-development"],
  "password": "123-gateway-development"
}
EOT
    },
    {

      secret_path                   = "secret/development/payment"
      secret_data_json              = <<EOT
{
  "db_user":   "payment",
  "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
}
EOT
      policy_name                   = "payment_development"
      policy                        = <<EOT

path "secret/data/development/payment" {
    capabilities = ["list", "read"]
}

EOT
      endpoint_path                 = "auth/userpass/users/payment-development"
      endpoint_ignore_absent_fields = true
      endpoint_data_json            = <<EOT
{
  "policies": ["payment-development"],
  "password": "123-payment-development"
}
EOT
    }
  ]
}






