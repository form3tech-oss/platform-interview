terraform {
  required_version = ">= 0.1.0.7"

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
  alias   = "vault_staging"
  address = "http://localhost:8401"
  token   = "6e64a48c-f759-40e2-806d-54778c3f1bd4"
}

resource "vault_generic_secret" "gateway_staging" {
  provider = vault.vault_staging
  path     = "secret/staging/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
}
EOT
}

resource "vault_policy" "gateway_staging" {
  provider = vault.vault_staging
  name     = "gateway-staging"

  policy = <<EOT

path "secret/data/staging/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_staging" {
  provider             = vault.vault_staging
  depends_on           = [vault_auth_backend.userpass_staging]
  path                 = "auth/userpass/users/gateway-staging"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-staging"],
  "password": "123-gateway-staging"
}
EOT
}

resource "docker_container" "gateway_staging" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=gateway-staging",
    "VAULT_PASSWORD=123-gateway-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}
