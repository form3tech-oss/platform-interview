resource "vault_generic_secret" "service" {
//  name     = "${var.service_name}-${var.env_name}"
  path     = "secret/${var.env_name}/${var.service_name}"

  data_json = <<EOT
{
  "db_user":   "${var.service_name}",
  "db_password": "${var.service_db_password}"
}
EOT
}

resource "vault_policy" "service" {
  name     = "${var.service_name}-${var.env_name}"

  policy = <<EOT

path "secret/data/${var.env_name}/${var.service_name}" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "service" {
//  name     = "${var.service_name}-${var.env_name}"
  depends_on           = [var.vault_auth_backend_userpass]
  path                 = "auth/userpass/users/${var.service_name}-${var.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.service_name}-${var.env_name}"],
  "password": "${var.service_password}"
}
EOT
}

resource "docker_container" "service" {
  name  = "${var.service_name}_${var.env_name}"
  image = "form3tech-oss/platformtest-${var.service_name}"
  logs = true

  env = [
    "VAULT_ADDR=http://vault-${var.env_name}:8200",
    "VAULT_USERNAME=${var.service_name}-${var.env_name}",
    "VAULT_PASSWORD=${var.service_password}",
    "ENVIRONMENT=${var.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${var.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}