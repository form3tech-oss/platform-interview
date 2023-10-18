resource "vault_audit" "audit" {
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass" {
  type     = "userpass"
}

resource "vault_generic_secret" "account" {
  path     = "secret/${var.env_name}/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "${var.account_db_password}"
}
EOT
}

resource "vault_policy" "account" {
  name     = "account-${var.env_name}"

  policy = <<EOT

path "secret/data/${var.env_name}/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/account-${var.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-${var.env_name}"],
  "password": "${var.account_password}"
}
EOT
}

resource "vault_generic_secret" "gateway" {
  path     = "secret/${var.env_name}/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "${var.gateway_db_password}"
}
EOT
}

resource "vault_policy" "gateway" {
  name     = "gateway-${var.env_name}"

  policy = <<EOT

path "secret/data/${var.env_name}/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/gateway-${var.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-${var.env_name}"],
  "password": "${var.gateway_password}"
}
EOT
}

resource "vault_generic_secret" "payment" {
  path     = "secret/${var.env_name}/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "${var.payment_db_password}"
}
EOT
}

resource "vault_policy" "payment" {
  name     = "payment-${var.env_name}"

  policy = <<EOT

path "secret/data/${var.env_name}/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/payment-${var.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-${var.env_name}"],
  "password": "${var.payment_password}"
}
EOT
}

resource "docker_container" "account" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_${var.env_name}"

  env = [
    "VAULT_ADDR=http://vault-${var.env_name}:8200",
    "VAULT_USERNAME=account-${var.env_name}",
    "VAULT_PASSWORD=${var.account_password}",
    "ENVIRONMENT=${var.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${var.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_${var.env_name}"

  env = [
    "VAULT_ADDR=http://vault-${var.env_name}:8200",
    "VAULT_USERNAME=gateway-${var.env_name}",
    "VAULT_PASSWORD=${var.gateway_password}",
    "ENVIRONMENT=${var.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${var.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_${var.env_name}"

  env = [
    "VAULT_ADDR=http://vault-${var.env_name}:8200",
    "VAULT_USERNAME=payment-${var.env_name}",
    "VAULT_PASSWORD=${var.payment_password}",
    "ENVIRONMENT=${var.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${var.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "frontend" {
  image = "docker.io/nginx:${var.nginx_version}"
  name  = "frontend_${var.env_name}"

  ports {
    internal = 80
    external = var.nginx_port
  }

  networks_advanced {
    name = "vagrant_${var.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}