#Environments inputs
environment_inputs = [
  #stage
  {
    env_name = "staging"
    nginx_port = 4082
    nginx_version = "latest"
    vault_address = "http://localhost:8401"
    vault_token = "f23612cf-824d-4206-9e94-e31a6dc8ee8e"
  }
]

#Services inputs
services_inputs = [
  #account app
  {
    service_name        = "account"
    service_db_password = "965d3c27-9e20-4d41-91c9-61e6631870e8"
    service_password    = "123-account-staging"
  },
  #payment app
  {
    service_name        = "payment"
    service_db_password = "a63e8938-6d49-49ea-905d-e03a683059e8"
    service_password    = "123-payment-staging"
  },
  #gateway app
  {
    service_name        = "gateway"
    service_db_password = "10350819-4802-47ac-9476-6fa781e35cfa"
    service_password    = "123-gateway-staging"
  }
]