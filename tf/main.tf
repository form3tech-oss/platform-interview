module "dev" {
  source = "./environments/dev"
  environment_inputs = var.environment_inputs_dev
  services_inputs = var.services_inputs_dev
}

module "prod" {
  source = "./environments/prod"
  environment_inputs = var.environment_inputs_prod
  services_inputs = var.services_inputs_prod
}

module "stage" {
  source = "./environments/stage"
  environment_inputs = var.environment_inputs_stage
  services_inputs = var.services_inputs_stage
}