resource "vault_audit" "this" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# Maybe should pass the whole data_json as var
resource "vault_generic_secret" "this" {
  path = "secret/${var.environment}/${var.service}"

  data_json = <<EOT
{
  "db_user":   "${var.db_user}",
  "db_password": "${var.db_password}"
}
EOT
}

resource "vault_policy" "this" {
  name = "${var.service}-${var.environment}"

  policy = <<EOT

path "secret/data/${var.environment}/${var.service}" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "this" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = format("auth/userpass/users/%s-%s", var.service, var.environment)
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.service}-${var.environment}"],
  "password": "${var.endpoint_password}"
}
EOT
}
