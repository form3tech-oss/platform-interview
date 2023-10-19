module "service" {
  count     = length(var.service_inputs)
  source    = "./service"
  env_name = var.env_name
  vault_auth_backend_userpass = vault_auth_backend.userpass
  service_name = element(var.service_inputs, count.index)["service_name"]
  service_db_password = element(var.service_inputs, count.index)["service_db_password"]
  service_password = element(var.service_inputs, count.index)["service_password"]
}