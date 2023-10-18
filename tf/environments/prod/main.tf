module "common" {
  source = "../../modules/common"
  env_name = "production"
  account_db_password = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
  account_password = "123-account-production"
  payment_db_password = "821462d7-47fb-402c-a22a-a58867602e39"
  payment_password = "123-payment-production"
  gateway_db_password = "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
  gateway_password = "123-gateway-production"
  nginx_port = 4081
  nginx_version = "1.22.0-alpine"
  providers = {
    vault = vault.prod
  }
}