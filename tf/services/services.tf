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