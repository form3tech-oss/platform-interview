module "services_dev" {
  source = "../../services"
  env_name = var.environment_inputs["env_name"]
  nginx_port = var.environment_inputs["nginx_port"]
  nginx_version = var.environment_inputs["nginx_version"]
  services_inputs = var.services_inputs
  providers = {
    vault=vault.dev
  }
}