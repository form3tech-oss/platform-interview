resource "vault_generic_secret" "this" {
  provider  = vault
  path      = var.VAULT_GENERIC_SECRET_PATH
  data_json = <<EOF
  {
    "db_user":   "${var.VAULT_GENERIC_SECRET_DATA_DB_USER}",
    "db_password": "${var.VAULT_GENERIC_SECRET_DATA_DB_PASSWORD}"
  } 
  EOF
}

resource "vault_policy" "this" {
  provider = vault
  name     = var.VAULT_POLICY_NAME
  policy   = data.vault_policy_document.this.hcl
}

data "vault_policy_document" "this" {
  rule {
    path         = var.VAULT_POLICY_PATH
    capabilities = var.VAULT_POLICY_CAPABILITIES
  }
}

resource "vault_generic_endpoint" "this" {
  provider             = vault
  depends_on           = [var.VAULT_AUTH_BACKEND]
  path                 = var.VAULT_GENERIC_ENDPOINT_PATH
  ignore_absent_fields = true

  data_json = <<EOF
  {
    "policies" : ["${var.VAULT_GENERIC_ENDPOINT_POLICIES}"],
    "password" : "${var.VAULT_GENERIC_ENDPOINT_PASSWORD}"
  }
  EOF
}

