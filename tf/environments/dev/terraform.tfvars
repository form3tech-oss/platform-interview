#Environments inputs
environment_inputs = {
    env_name = "development"
    nginx_port = 4080
    nginx_version = "latest"
    vault_address = "http://localhost:8201"
    vault_token = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}


#Services inputs
services_inputs = [
  #account app
  {
    service_name        = "account"
    service_db_password = "965d3c27-9e20-4d41-91c9-61e6631870e7"
    service_password    = "123-account-development"
  },
  #payment app
  {
    service_name        = "payment"
    service_db_password = "a63e8938-6d49-49ea-905d-e03a683059e7"
    service_password    = "123-payment-development"
  },
  #gateway app
  {
    service_name        = "gateway"
    service_db_password = "10350819-4802-47ac-9476-6fa781e35cfd"
    service_password    = "123-gateway-development"
  }
]