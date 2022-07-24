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

resource "vault_generic_secret" "payment_staging" {
  provider = vault.vault_staging
  path     = "secret/staging/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "821462d7-47fb-402c-a22a-a58867602e39"
}
EOT
}

resource "vault_policy" "payment_staging" {
  provider = vault.vault_staging
  name     = "payment-staging"

  policy = <<EOT

path "secret/data/staging/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_staging" {
  provider             = vault.vault_staging
  depends_on           = [vault_auth_backend.userpass_staging]
  path                 = "auth/userpass/users/payment-staging"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-staging"],
  "password": "123-payment-staging"
}
EOT
}

resource "docker_container" "payment_staging" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=payment-staging",
    "VAULT_PASSWORD=123-payment-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}
