provider "vault" {
  address = "http://localhost:8201"
  token   = var.vault_token
}

resource "vault_audit" "file" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

module "account_service" {
  source            = "../modules/vault"
  environment       = var.environment
  service           = "account"
  db_user           = var.account_service.db_user
  db_password       = var.account_service.db_password
  docker_image      = var.account_service.docker_image
  endpoint_password = var.account_service.endpoint_password
  depends_on        = [vault_auth_backend.userpass]
}

module "gateway_service" {
  source            = "../modules/vault"
  environment       = var.environment
  service           = "gateway"
  db_user           = var.gateway_service.db_user
  db_password       = var.gateway_service.db_password
  docker_image      = var.gateway_service.docker_image
  endpoint_password = var.gateway_service.endpoint_password
  depends_on        = [vault_auth_backend.userpass]
}

module "payment_service" {
  source            = "../modules/vault"
  environment       = var.environment
  service           = "payment"
  db_user           = var.payment_service.db_user
  db_password       = var.payment_service.db_password
  docker_image      = var.payment_service.docker_image
  endpoint_password = var.payment_service.endpoint_password
  depends_on        = [vault_auth_backend.userpass]
}

resource "docker_container" "frontend" {
  image = "docker.io/nginx:latest"
  name  = "frontend_${var.environment}"

  ports {
    internal = 80
    external = 4070
  }

  networks_advanced {
    name = "vagrant-development"
  }

  lifecycle {
    ignore_changes = all
  }
}
