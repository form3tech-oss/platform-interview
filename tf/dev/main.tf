terraform {
  required_version = ">= 1.0.7"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }

    vault = {
      version = "3.0.1"
    }
  }
}


/* 
variables section
*/

variable "token" {
  type        = string
  default     = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
  description = "dev token"
}

variable "vault_services_vars" {
  type = map(object({
    name                          = string
    secret_path                   = string
    secret_data_json              = string
    policy_name                   = string
    policy                        = string
    endpoint_path                 = string
    endpoint_ignore_absent_fields = bool
    username                      = string
    password                      = string
    endpoint_data_json            = string
  }))
  default = {
    "account" = {
      name                          = "account"
      secret_path                   = "secret/development/account"
      secret_data_json              = <<EOT
      {
        "db_user" : "account",
        "db_password" : "965d3c27-9e20-4d41-91c9-61e6631870e7"
      }
EOT
      policy_name                   = "account_development"
      policy                        = <<EOT
        path "secret/data/development/account" {
        capabilities = ["list", "read"]
      }
EOT
      endpoint_path                 = "auth/userpass/users/account_development"
      endpoint_ignore_absent_fields = true
      username                      = "account_development"
      password                      = "123-account-development"
      endpoint_data_json            = <<EOT
      {
        "policies" : ["account_development"],
        "password" : "123-account-development"
      }
EOT
    },
    "gateway" = {
      name             = "gateway"
      secret_path      = "secret/development/gateway"
      secret_data_json = <<EOT
      {
        "db_user" : "gateway",
        "db_password" : "10350819-4802-47ac-9476-6fa781e35cfd"
      }
EOT
      policy_name      = "gateway_development"
      policy           = <<EOT
        path "secret/data/development/gateway" {
        capabilities = ["list", "read"]
      }
EOT

      endpoint_path                 = "auth/userpass/users/gateway_development"
      endpoint_ignore_absent_fields = true
      username                      = "gateway_development"
      password                      = "123-gateway-development"
      endpoint_data_json            = <<EOT
      {
        "policies" : ["gateway_development"],
        "password" : "123-gateway-development"
      }
EOT
    },
    "payment" = {
      name                          = "payment"
      secret_path                   = "secret/development/payment"
      secret_data_json              = <<EOT
      {
        "db_user" : "payment",
        "db_password" : "a63e8938-6d49-49ea-905d-e03a683059e7"
      }
EOT
      policy_name                   = "payment_development"
      policy                        = <<EOT
        path "secret/data/development/payment" {
        capabilities = ["list", "read"]
      }
EOT
      endpoint_path                 = "auth/userpass/users/payment_development"
      endpoint_ignore_absent_fields = true
      username                      = "payment_development"
      password                      = "123-payment-development"
      endpoint_data_json            = <<EOT
      {
        "policies" : ["payment_development"],
        "password" : "123-payment-development"
      }
EOT
    }
  }
}

/* 
variables section
*/


/* 
resources section
*/

provider "vault" {
  alias   = "vault_dev"
  address = "http://localhost:8201"
  token   = var.token
}

resource "vault_audit" "audit_dev" {
  provider = vault.vault_dev
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_dev" {
  provider = vault.vault_dev
  type     = "userpass"
}

resource "vault_generic_secret" "payment_development" {
  for_each  = var.vault_services_vars
  provider  = vault.vault_dev
  path      = each.value.secret_path
  data_json = each.value.secret_data_json
}

resource "vault_policy" "policy_development" {
  for_each = var.vault_services_vars
  provider = vault.vault_dev
  name     = each.value.policy_name
  policy   = each.value.policy
}

resource "vault_generic_endpoint" "endpoint_development" {
  for_each             = var.vault_services_vars
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = each.value.endpoint_path
  ignore_absent_fields = each.value.endpoint_ignore_absent_fields
  data_json            = each.value.endpoint_data_json
}

resource "docker_container" "container_development" {
  for_each = var.vault_services_vars
  image    = "form3tech-oss/platformtest-${each.value.name}"
  name     = each.value.policy_name

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=${each.value.username}",
    "VAULT_PASSWORD=${each.value.password}",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "frontend_development" {
  image = "docker.io/nginx:latest"
  name  = "frontend_development"

  ports {
    internal = 80
    external = 4080
  }

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

/* 
resources section
*/
