## Vault
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
  path                 = format("auth/userpass/users/%s-%s", var.service, var.environment)
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.service}-${var.environment}"],
  "password": "${var.endpoint_password}"
}
EOT
}

## Docker Container
resource "docker_container" "this" {
  image = var.docker_image
  name  = "${var.service}_${var.environment}"

  env = [
    "VAULT_ADDR=http://vault-${var.environment}:8200",
    "VAULT_USERNAME=${var.service}-${var.environment}",
    "VAULT_PASSWORD=${var.endpoint_password}",
    "ENVIRONMENT=${var.environment}"
  ]

  networks_advanced {
    name = "vagrant-${var.environment}"
  }

  lifecycle {
    ignore_changes = all
  }
}
