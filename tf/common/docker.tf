module "DOCKER_ACCOUNT" {
  source       = "../../modules/services/docker"
  IMAGE        = local.config_yaml.ACCOUNT.DOCKER_IMAGE
  NAME         = local.config_yaml.ACCOUNT.DOCKER_CONTAINER_NAME
  ENV_VARS     = local.config_yaml.ACCOUNT.DOCKER_ENV_VARS
  NETWORK_NAME = local.config_yaml.ACCOUNT.DOCKER_NETWORK_NAME
}

module "DOCKER_GATEWAY" {
  source       = "../../modules/services/docker"
  IMAGE        = local.config_yaml.GATEWAY.DOCKER_IMAGE
  NAME         = local.config_yaml.GATEWAY.DOCKER_CONTAINER_NAME
  ENV_VARS     = local.config_yaml.GATEWAY.DOCKER_ENV_VARS
  NETWORK_NAME = local.config_yaml.GATEWAY.DOCKER_NETWORK_NAME
}

module "DOCKER_PAYMENT" {
  source       = "../../modules/services/docker"
  IMAGE        = local.config_yaml.PAYMENT.DOCKER_IMAGE
  NAME         = local.config_yaml.PAYMENT.DOCKER_CONTAINER_NAME
  ENV_VARS     = local.config_yaml.PAYMENT.DOCKER_ENV_VARS
  NETWORK_NAME = local.config_yaml.PAYMENT.DOCKER_NETWORK_NAME
}

module "DOCKER_FRONTEND" {
  source                 = "../../modules/services/docker"
  IMAGE                  = local.config_yaml.FRONTEND.DOCKER_IMAGE
  NAME                   = local.config_yaml.FRONTEND.DOCKER_CONTAINER_NAME
  ENV_VARS               = local.config_yaml.FRONTEND.DOCKER_ENV_VARS
  NETWORK_NAME           = local.config_yaml.FRONTEND.DOCKER_NETWORK_NAME
  FRONTEND_CONTAINER     = local.config_yaml.FRONTEND.FRONTEND_CONTAINER
  FRONTEND_INTERNAL_PORT = local.config_yaml.FRONTEND.FRONTEND_INTERNAL_PORT
  FRONTEND_EXTERNAL_PORT = local.config_yaml.FRONTEND.FRONTEND_EXTERNAL_PORT
}
