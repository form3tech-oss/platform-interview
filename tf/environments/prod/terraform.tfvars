#Environments inputs
environment_inputs = [
  #prod
  {
    env_name = "production"
    nginx_port = 4081
    nginx_version = "1.22.0-alpine"
    vault_address = "http://localhost:8301"
    vault_token = "083672fc-4471-4ec4-9b59-a285e463a973"
  }
]

#Services inputs
services_inputs = [
  #account app
  {
    service_name        = "account"
    service_db_password = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
    service_password    = "123-account-production"
  },
  #payment app
  {
    service_name        = "payment"
    service_db_password = "821462d7-47fb-402c-a22a-a58867602e39"
    service_password    = "123-payment-production"
  },
  #gateway app
  {
    service_name        = "gateway"
    service_db_password = "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
    service_password    = "123-gateway-production"
  }
]