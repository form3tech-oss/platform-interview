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
  default     = "083672fc-4471-4ec4-9b59-a285e463a973"
  description = "prod token"
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
      secret_path                   = "secret/production/account"
      secret_data_json              = <<EOT
      {
        "db_user" : "account",
        "db_password" : "965d3c27-9e20-4d41-91c9-61e6631870e7"
      }
EOT
      policy_name                   = "account_production"
      policy                        = <<EOT
        path "secret/data/production/account" {
        capabilities = ["list", "read"]
      }
EOT
      endpoint_path                 = "auth/userpass/users/account_production"
      endpoint_ignore_absent_fields = true
      username                      = "account_production"
      password                      = "123-account-production"
      endpoint_data_json            = <<EOT
      {
        "policies" : ["account_production"],
        "password" : "123-account-production"
      }
EOT
    },
    "gateway" = {
      name             = "gateway"
      secret_path      = "secret/production/gateway"
      secret_data_json = <<EOT
      {
        "db_user" : "gateway",
        "db_password" : "10350819-4802-47ac-9476-6fa781e35cfd"
      }
EOT
      policy_name      = "gateway_production"
      policy           = <<EOT
        path "secret/data/production/gateway" {
        capabilities = ["list", "read"]
      }
EOT

      endpoint_path                 = "auth/userpass/users/gateway_production"
      endpoint_ignore_absent_fields = true
      username                      = "gateway_production"
      password                      = "123-gateway-production"
      endpoint_data_json            = <<EOT
      {
        "policies" : ["gateway_production"],
        "password" : "123-gateway-production"
      }
EOT
    },
    "payment" = {
      name                          = "payment"
      secret_path                   = "secret/production/payment"
      secret_data_json              = <<EOT
      {
        "db_user" : "payment",
        "db_password" : "a63e8938-6d49-49ea-905d-e03a683059e7"
      }
EOT
      policy_name                   = "payment_production"
      policy                        = <<EOT
        path "secret/data/production/payment" {
        capabilities = ["list", "read"]
      }
EOT
      endpoint_path                 = "auth/userpass/users/payment_production"
      endpoint_ignore_absent_fields = true
      username                      = "payment_production"
      password                      = "123-payment-production"
      endpoint_data_json            = <<EOT
      {
        "policies" : ["payment_production"],
        "password" : "123-payment-production"
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
  alias   = "vault_prod"
  address = "http://localhost:8301"
  token   = var.token
}

resource "vault_audit" "audit_prod" {
  provider = vault.vault_prod
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_prod" {
  provider = vault.vault_prod
  type     = "userpass"
}

resource "vault_generic_secret" "payment_production" {
  for_each  = var.vault_services_vars
  provider  = vault.vault_prod
  path      = each.value.secret_path
  data_json = each.value.secret_data_json
}

resource "vault_policy" "policy_production" {
  for_each = var.vault_services_vars
  provider = vault.vault_prod
  name     = each.value.policy_name
  policy   = each.value.policy
}

resource "vault_generic_endpoint" "endpoint_production" {
  for_each             = var.vault_services_vars
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = each.value.endpoint_path
  ignore_absent_fields = each.value.endpoint_ignore_absent_fields
  data_json            = each.value.endpoint_data_json
}

resource "docker_container" "container_production" {
  for_each = var.vault_services_vars
  image    = "form3tech-oss/platformtest-${each.value.name}"
  name     = each.value.policy_name

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=${each.value.username}",
    "VAULT_PASSWORD=${each.value.password}",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "frontend_production" {
  image = "docker.io/nginx:latest"
  name  = "frontend_production"

  ports {
    internal = 80
    external = 4081
  }

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

/* 
resources section
*/
