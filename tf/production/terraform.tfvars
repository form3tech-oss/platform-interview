environment = "production"

account_service = {
  db_password       = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
  db_user           = "account"
  docker_image      = "form3tech-oss/platformtest-account"
  endpoint_password = "123-account-production"
}

gateway_service = {
  db_password       = "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
  db_user           = "gateway"
  docker_image      = "form3tech-oss/platformtest-gateway"
  endpoint_password = "123-gateway-production"
}

payment_service = {
  db_password       = "821462d7-47fb-402c-a22a-a58867602e39"
  db_user           = "payment"
  docker_image      = "form3tech-oss/platformtest-payment"
  endpoint_password = "123-payment-production"
}

vault_token = "083672fc-4471-4ec4-9b59-a285e463a973"
