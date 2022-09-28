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

provider "vault" {
  address = "http://localhost:8201"
  token   = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}

provider "vault" {
  alias   = "vault_dev"
  address = "http://localhost:8201"
  token   = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}

provider "vault" {
  alias   = "vault_prod"
  address = "http://localhost:8301"
  token   = "083672fc-4471-4ec4-9b59-a285e463a973"
}

resource "vault_audit" "audit_dev" {
  provider = vault.vault_dev
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_audit" "audit_prod" {
  provider = vault.vault_prod
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_dev" {
  provider = vault.vault_dev
  type     = "userpass"
}


resource "vault_auth_backend" "userpass_prod" {
  provider = vault.vault_prod
  type     = "userpass"
}

resource "vault_generic_secret" "account_development" {
  provider = vault.vault_dev
  path     = "secret/development/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
}
EOT
}

resource "vault_policy" "account_development" {
  provider = vault.vault_dev
  name     = "account-development"

  policy = <<EOT

path "secret/data/development/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account_development" {
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/account-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-development"],
  "password": "123-account-development"
}
EOT
}

resource "vault_generic_secret" "gateway_development" {
  provider = vault.vault_dev
  path     = "secret/development/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
}
EOT
}

resource "vault_policy" "gateway_development" {
  provider = vault.vault_dev
  name     = "gateway-development"

  policy = <<EOT

path "secret/data/development/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_development" {
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/gateway-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-development"],
  "password": "123-gateway-development"
}
EOT
}
resource "vault_generic_secret" "payment_development" {
  provider = vault.vault_dev
  path     = "secret/development/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
}
EOT
}

resource "vault_policy" "payment_development" {
  provider = vault.vault_dev
  name     = "payment-development"

  policy = <<EOT

path "secret/data/development/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_development" {
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/payment-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-development"],
  "password": "123-payment-development"
}
EOT
}

resource "vault_generic_secret" "account_production" {
  provider = vault.vault_prod
  path     = "secret/production/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
}
EOT
}

resource "vault_policy" "account_production" {
  provider = vault.vault_prod
  name     = "account-production"

  policy = <<EOT

path "secret/data/production/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account_production" {
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/account-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-production"],
  "password": "123-account-production"
}
EOT
}

resource "vault_generic_secret" "gateway_production" {
  provider = vault.vault_prod
  path     = "secret/production/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
}
EOT
}

resource "vault_policy" "gateway_production" {
  provider = vault.vault_prod
  name     = "gateway-production"

  policy = <<EOT

path "secret/data/production/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_production" {
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/gateway-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-production"],
  "password": "123-gateway-production"
}
EOT
}

resource "vault_generic_secret" "payment_production" {
  provider = vault.vault_prod
  path     = "secret/production/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "821462d7-47fb-402c-a22a-a58867602e39"
}
EOT
}

resource "vault_policy" "payment_production" {
  provider = vault.vault_prod
  name     = "payment-production"

  policy = <<EOT

path "secret/data/production/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_production" {
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/payment-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-production"],
  "password": "123-payment-production"
}
EOT
}

resource "docker_container" "account_production" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=account-production",
    "VAULT_PASSWORD=123-account-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_production" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=gateway-production",
    "VAULT_PASSWORD=123-gateway-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment_production" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=payment-production",
    "VAULT_PASSWORD=123-payment-production",
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
  image = "docker.io/nginx:1.22.0-alpine"
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

resource "docker_container" "account_development" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=account-development",
    "VAULT_PASSWORD=123-account-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_development" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=gateway-development",
    "VAULT_PASSWORD=123-gateway-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment_development" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=payment-development",
    "VAULT_PASSWORD=123-payment-development",
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
