module "service" {
  count     = length(var.services_inputs)
  source    = "./service"
  env_name = var.env_name
  vault_auth_backend_userpass = vault_auth_backend.userpass
  service_image = element(var.services_inputs, count.index)["service_image"]
  service_name = element(var.services_inputs, count.index)["service_name"]
  service_db_password = element(var.services_inputs, count.index)["service_db_password"]
  service_password = element(var.services_inputs, count.index)["service_password"]
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