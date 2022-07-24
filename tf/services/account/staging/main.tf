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

resource "vault_generic_secret" "account_staging" {
  provider = vault.vault_staging
  path     = "secret/staging/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
}
EOT
}

resource "vault_policy" "account_staging" {
  provider = vault.vault_staging
  name     = "account-staging"

  policy = <<EOT

path "secret/data/staging/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account_staging" {
  provider             = vault.vault_staging
  depends_on           = [vault_auth_backend.userpass_staging]
  path                 = "auth/userpass/users/account-staging"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-staging"],
  "password": "123-account-staging"
}
EOT
}

resource "docker_container" "account_staging" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=account-staging",
    "VAULT_PASSWORD=123-account-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}
