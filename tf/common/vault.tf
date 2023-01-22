resource "vault_audit" "this" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "this" {
  type = local.config_yaml.VAULT.AUTH_BACKEND.TYPE
}


##################################################################################

module "account" {

  source             = "../../modules/services/vault"
  VAULT_AUTH_BACKEND = vault_auth_backend.this

  VAULT_GENERIC_SECRET_PATH = local.config_yaml.ACCOUNT.VAULT_GENERIC_SECRET_PATH

  VAULT_GENERIC_SECRET_DATA_DB_USER     = local.config_yaml.ACCOUNT.GENERIC_SECRET_DATA_DB_USER
  VAULT_GENERIC_SECRET_DATA_DB_PASSWORD = local.config_yaml.ACCOUNT.GENERIC_SECRET_DATA_DB_PASSWORD

  VAULT_POLICY_NAME = local.config_yaml.ACCOUNT.VAULT_POLICY_NAME

  VAULT_POLICY_CAPABILITIES       = split(",", local.config_yaml.ACCOUNT.VAULT_POLICY_CAPABILITIES)
  VAULT_POLICY_PATH               = local.config_yaml.ACCOUNT.VAULT_POLICY_PATH
  VAULT_GENERIC_ENDPOINT_PATH     = local.config_yaml.ACCOUNT.VAULT_GENERIC_ENDPOINT_PATH
  VAULT_GENERIC_ENDPOINT_POLICIES = local.config_yaml.ACCOUNT.VAULT_GENERIC_ENDPOINT_POLICIES
  VAULT_GENERIC_ENDPOINT_PASSWORD = local.config_yaml.ACCOUNT.VAULT_GENERIC_ENDPOINT_PASSWORD
}

##################################################################################

module "gateway" {

  source             = "../../modules/services/vault"
  VAULT_AUTH_BACKEND = vault_auth_backend.this

  VAULT_GENERIC_SECRET_PATH = local.config_yaml.GATEWAY.VAULT_GENERIC_SECRET_PATH

  VAULT_GENERIC_SECRET_DATA_DB_USER     = local.config_yaml.GATEWAY.GENERIC_SECRET_DATA_DB_USER
  VAULT_GENERIC_SECRET_DATA_DB_PASSWORD = local.config_yaml.GATEWAY.GENERIC_SECRET_DATA_DB_PASSWORD

  VAULT_POLICY_NAME = local.config_yaml.GATEWAY.VAULT_POLICY_NAME

  VAULT_POLICY_CAPABILITIES       = split(",", local.config_yaml.GATEWAY.VAULT_POLICY_CAPABILITIES)
  VAULT_POLICY_PATH               = local.config_yaml.GATEWAY.VAULT_POLICY_PATH
  VAULT_GENERIC_ENDPOINT_PATH     = local.config_yaml.GATEWAY.VAULT_GENERIC_ENDPOINT_PATH
  VAULT_GENERIC_ENDPOINT_POLICIES = local.config_yaml.GATEWAY.VAULT_GENERIC_ENDPOINT_POLICIES
  VAULT_GENERIC_ENDPOINT_PASSWORD = local.config_yaml.GATEWAY.VAULT_GENERIC_ENDPOINT_PASSWORD
}

##################################################################################

module "payment" {

  source             = "../../modules/services/vault"
  VAULT_AUTH_BACKEND = vault_auth_backend.this

  VAULT_GENERIC_SECRET_PATH = local.config_yaml.PAYMENT.VAULT_GENERIC_SECRET_PATH

  VAULT_GENERIC_SECRET_DATA_DB_USER     = local.config_yaml.PAYMENT.GENERIC_SECRET_DATA_DB_USER
  VAULT_GENERIC_SECRET_DATA_DB_PASSWORD = local.config_yaml.PAYMENT.GENERIC_SECRET_DATA_DB_PASSWORD

  VAULT_POLICY_NAME = local.config_yaml.PAYMENT.VAULT_POLICY_NAME

  VAULT_POLICY_CAPABILITIES       = split(",", local.config_yaml.PAYMENT.VAULT_POLICY_CAPABILITIES)
  VAULT_POLICY_PATH               = local.config_yaml.PAYMENT.VAULT_POLICY_PATH
  VAULT_GENERIC_ENDPOINT_PATH     = local.config_yaml.PAYMENT.VAULT_GENERIC_ENDPOINT_PATH
  VAULT_GENERIC_ENDPOINT_POLICIES = local.config_yaml.PAYMENT.VAULT_GENERIC_ENDPOINT_POLICIES
  VAULT_GENERIC_ENDPOINT_PASSWORD = local.config_yaml.PAYMENT.VAULT_GENERIC_ENDPOINT_PASSWORD
}
