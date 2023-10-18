resource "vault_audit" "audit" {
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass" {
  type     = "userpass"
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

module "account" {
  source = "./service"
  env_name = var.env_name
  service_name = "account"
  vault_auth_backend_userpass = vault_auth_backend.userpass
  service_db_password = "965d3c27-9e20-4d41-91c9-61e6631870e7"
  service_password = "123-account-development"
}

module "payment" {
  source = "./service"
  env_name = var.env_name
  service_name = "payment"
  vault_auth_backend_userpass = vault_auth_backend.userpass
  service_db_password = "a63e8938-6d49-49ea-905d-e03a683059e7"
  service_password = "123-payment-development"
}

module "gateway" {
  source = "./service"
  env_name = var.env_name
  service_name = "gateway"
  vault_auth_backend_userpass = vault_auth_backend.userpass
  service_db_password = "10350819-4802-47ac-9476-6fa781e35cfd"
  service_password = "123-gateway-development"
}