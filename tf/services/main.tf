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