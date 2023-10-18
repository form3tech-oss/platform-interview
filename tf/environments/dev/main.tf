module "common" {
  source = "../../modules/common"
  env_name = "development"
  account_db_password = "965d3c27-9e20-4d41-91c9-61e6631870e7"
  account_password = "123-account-development"
  payment_db_password = "a63e8938-6d49-49ea-905d-e03a683059e7"
  payment_password = "123-payment-development"
  gateway_db_password = "10350819-4802-47ac-9476-6fa781e35cfd"
  gateway_password = "123-gateway-development"
  nginx_port = 4080
  nginx_version = "latest"
  providers = {
    vault = vault.dev
  }
}