data "rename" "form3" {
  cwd_name = path.cwd
  env_name = "${cwd_name == "dev" ? "development" : "production"}"
  vault_name = "vault_${cmd_name}"
}

resource "vault_audit" "audit" {
  provider = vault.alias
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass" {
  provider = vault.alias
  type     = "userpass"
}

resource "vault_generic_secret" "account" {
  provider = vault.alias
  path     = "secret/${data.rename.form3.env_name}/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
}
EOT
}

resource "vault_policy" "account" {
  provider = vault.alias
  name     = "account-${data.rename.form3.env_name}"

  policy = <<EOT

path "secret/data/${data.rename.form3.env_name}/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account" {
  provider             = vault.alias
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/account-${data.rename.form3.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-${data.rename.form3.env_name}"],
  "password": "123-account-${data.rename.form3.env_name}"
}
EOT
}

resource "vault_generic_secret" "gateway" {
  provider = vault.alias
  path     = "secret/${data.rename.form3.env_name}/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
}
EOT
}

resource "vault_policy" "gateway" {
  provider = vault.alias
  name     = "gateway-${data.rename.form3.env_name}"

  policy = <<EOT

path "secret/data/${data.rename.form3.env_name}/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway" {
  provider             = vault.alias
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/gateway-${data.rename.form3.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-${data.rename.form3.env_name}"],
  "password": "123-gateway-${data.rename.form3.env_name}"
}
EOT
}
resource "vault_generic_secret" "payment" {
  provider = vault.alias
  path     = "secret/${data.rename.form3.env_name}/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
}
EOT
}

resource "vault_policy" "payment" {
  provider = vault.alias
  name     = "payment-${data.rename.form3.env_name}"

  policy = <<EOT

path "secret/data/${data.rename.form3.env_name}/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment" {
  provider             = vault.alias
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/payment-${data.rename.form3.env_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-${data.rename.form3.env_name}"],
  "password": "123-payment-${data.rename.form3.env_name}"
}
EOT
}

resource "docker_container" "account" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_${data.rename.form3.env_name}"

  env = [
    "VAULT_ADDR=http://vault-${data.rename.form3.env_name}:8200",
    "VAULT_USERNAME=account-${data.rename.form3.env_name}",
    "VAULT_PASSWORD=123-account-${data.rename.form3.env_name}",
    "ENVIRONMENT=${data.rename.form3.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${data.rename.form3.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_${data.rename.form3.env_name}"

  env = [
    "VAULT_ADDR=http://vault-${data.rename.form3.env_name}:8200",
    "VAULT_USERNAME=gateway-${data.rename.form3.env_name}",
    "VAULT_PASSWORD=123-gateway-${data.rename.form3.env_name}",
    "ENVIRONMENT=${data.rename.form3.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${data.rename.form3.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_${data.rename.form3.env_name}"

  env = [
    "VAULT_ADDR=http://vault-${data.rename.form3.env_name}:8200",
    "VAULT_USERNAME=payment-${data.rename.form3.env_name}",
    "VAULT_PASSWORD=123-payment-${data.rename.form3.env_name}",
    "ENVIRONMENT=${data.rename.form3.env_name}"
  ]

  networks_advanced {
    name = "vagrant_${data.rename.form3.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "frontend" {
  image = "docker.io/nginx:latest"
  name  = "frontend_${data.rename.form3.env_name}"

  ports {
    internal = 80
    external = 4080
  }

  networks_advanced {
    name = "vagrant_${data.rename.form3.env_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}