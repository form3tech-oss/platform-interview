terraform {
  required_version = ">= 0.1.0.7"

  required_providers {
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

resource "vault_audit" "audit_staging" {
  provider = vault.vault_staging
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_staging" {
  provider = vault.vault_staging
  type     = "userpass"
}