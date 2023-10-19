module "services" {
  source = "./services"
  env_name = var.env_name
  nginx_port = var.nginx_port
  nginx_version = var.nginx_version
  service_inputs = var.service_inputs
  providers = {
    vault=vault.stage
  }
}