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
  alias   = "vault_provider"
  address = "http://localhost:${var.vault_port}"
  token   = "${var.vault_token}"
}


#############
# RESOURCES #
#############
resource "vault_auth_backend" "userpass" {
  provider = vault.vault_provider
  type     = "userpass"
}


###########
# ACCOUNT #
###########
resource "vault_generic_secret" "account" {
  provider = vault.vault_provider
  path     = "secret/${var.environment_path}/account"

  data_json = <<EOT
{
  "db_user":   "${var.vault_account_db_user}",
  "db_password": "${var.vault_account_db_password}"
}
EOT
}

resource "vault_policy" "account" {
  provider = vault.vault_provider
  name     = "${var.vault_policy_account_name}"

  policy = <<EOT
path "secret/data/${var.environment_path}/account" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "account" {
  provider             = vault.vault_provider
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/account-${var.environment_path}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.vault_account_ep_username}"],
  "password": "${var.vault_account_ep_password}"
}
EOT
}


###########
# GATEWAY #
###########
resource "vault_generic_secret" "gateway" {
  provider = vault.vault_provider
  path     = "secret/${var.environment_path}/gateway"

  data_json = <<EOT
{
  "db_user":   "${var.vault_gateway_db_user}",
  "db_password": "${var.vault_gateway_db_password}"
}
EOT
}

resource "vault_policy" "gateway" {
  provider = vault.vault_provider
  name     = "${var.vault_policy_gateway_name}"

  policy = <<EOT
path "secret/data/${var.environment_path}/gateway" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "gateway" {
  provider             = vault.vault_provider
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/gateway-${var.environment_path}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.vault_gateway_ep_username}"],
  "password": "${var.vault_gateway_ep_password}"
}
EOT
}


###########
# PAYMENT #
###########
resource "vault_generic_secret" "payment" {
  provider = vault.vault_provider
  path     = "secret/${var.environment_path}/payment"

  data_json = <<EOT
{
  "db_user":   "${var.vault_payment_db_user}",
  "db_password": "${var.vault_payment_db_password}"
}
EOT
}

resource "vault_policy" "payment" {
  provider = vault.vault_provider
  name     = "${var.vault_policy_payment_name}"

  policy = <<EOT
path "secret/data/${var.environment_path}/payment" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "payment" {
  provider             = vault.vault_provider
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/payment-${var.environment_path}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.vault_payment_ep_username}"],
  "password": "${var.vault_payment_ep_password}"
}
EOT
}



##############
#            #
# CONTAINERS #
#            #
##############
resource "docker_container" "payment_container" {
  image = "form3tech-oss/platformtest-payment"
  name  = "${var.service_name_payment}"

  env = [
    "VAULT_ADDR=${var.vault_internal_addr}",
    "VAULT_USERNAME=${var.vault_payment_ep_username}",
    "VAULT_PASSWORD=${var.vault_payment_ep_password}",
    "ENVIRONMENT=${var.environment}"
  ]

  networks_advanced {
    name = "${var.network_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "account_container" {
  image = "form3tech-oss/platformtest-account"
  name  = "${var.service_name_account}"

  env = [
    "VAULT_ADDR=${var.vault_internal_addr}",
    "VAULT_USERNAME=${var.vault_account_ep_username}",
    "VAULT_PASSWORD=${var.vault_account_ep_password}",
    "ENVIRONMENT=${var.environment}"
  ]

  networks_advanced {
    name = "${var.network_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_container" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "${var.service_name_gateway}"

  env = [
    "VAULT_ADDR=${var.vault_internal_addr}",
    "VAULT_USERNAME=${var.vault_gateway_ep_username}",
    "VAULT_PASSWORD=${var.vault_gateway_ep_password}",
    "ENVIRONMENT=${var.environment}"
  ]

  networks_advanced {
    name = "${var.network_name}"
  }

  lifecycle {
    ignore_changes = all
  }
}
