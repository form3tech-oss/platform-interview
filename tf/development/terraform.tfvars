environment = "development"

account_service_credentials = {
  db_password       = "965d3c27-9e20-4d41-91c9-61e6631870e7"
  db_user           = "account"
  endpoint_password = "123-account-development"
}

gateway_service_credentials = {
  db_password       = "965d3c27-9e20-4d41-91c9-61e6631870e7"
  db_user           = "gateway"
  endpoint_password = "123-gateway-development"
}

payment_service_credentials = {
  db_password       = "965d3c27-9e20-4d41-91c9-61e6631870e7"
  db_user           = "payment"
  endpoint_password = "123-payment-development"
}

account_service_docker_image = "form3tech-oss/platformtest-account"
gateway_service_docker_image = "form3tech-oss/platformtest-gateway"
payment_service_docker_image = "form3tech-oss/platformtest-payment"

vault_token = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
