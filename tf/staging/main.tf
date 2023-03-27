provider "vault" {
  address = "http://localhost:8301"
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
  source            = "../modules/service_setup"
  environment       = var.environment
  service           = "account"
  db_user           = var.account_service_credentials.db_user
  db_password       = var.account_service_credentials.db_password
  docker_image      = var.account_service_docker_image
  endpoint_password = var.account_service_credentials.endpoint_password
  depends_on        = [vault_auth_backend.userpass]
}

module "gateway_service" {
  source            = "../modules/service_setup"
  environment       = var.environment
  service           = "gateway"
  db_user           = var.gateway_service_credentials.db_user
  db_password       = var.gateway_service_credentials.db_password
  docker_image      = var.gateway_service_docker_image
  endpoint_password = var.gateway_service_credentials.endpoint_password
  depends_on        = [vault_auth_backend.userpass]
}

module "payment_service" {
  source            = "../modules/service_setup"
  environment       = var.environment
  service           = "payment"
  db_user           = var.payment_service_credentials.db_user
  db_password       = var.payment_service_credentials.db_password
  docker_image      = var.payment_service_docker_image
  endpoint_password = var.payment_service_credentials.endpoint_password
  depends_on        = [vault_auth_backend.userpass]
}

resource "docker_container" "frontend" {
  image = "docker.io/nginx:latest"
  name  = "frontend_${var.environment}"

  ports {
    internal = 80
    external = 4090
  }

  networks_advanced {
    name = "vagrant-${var.environment}"
  }

  lifecycle {
    ignore_changes = all
  }
}
