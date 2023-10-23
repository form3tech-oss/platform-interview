#Dev environment inputs
environment_inputs_dev = {
    env_name = "development"
    nginx_port = 4080
    nginx_version = "latest"
    vault_address = "http://localhost:8201"
    vault_token = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}


#Dev services inputs
services_inputs_dev = [
  #account app
  {
    service_image       = "form3tech-oss/platformtest-account"
    service_name        = "account"
    service_db_password = "965d3c27-9e20-4d41-91c9-61e6631870e7"
    service_password    = "123-account-development"
  },
  #payment app
  {
    service_image       = "form3tech-oss/platformtest-payment"
    service_name        = "payment"
    service_db_password = "a63e8938-6d49-49ea-905d-e03a683059e7"
    service_password    = "123-payment-development"
  },
  #gateway app
  {
    service_image       = "form3tech-oss/platformtest-gateway"
    service_name        = "gateway"
    service_db_password = "10350819-4802-47ac-9476-6fa781e35cfd"
    service_password    = "123-gateway-development"
  }
]


#Prod environment inputs
environment_inputs_prod = {
    env_name = "production"
    nginx_port = 4081
    nginx_version = "1.22.0-alpine"
    vault_address = "http://localhost:8301"
    vault_token = "083672fc-4471-4ec4-9b59-a285e463a973"
}

#Prod services inputs
services_inputs_prod = [
  #account app
  {
    service_image       = "form3tech-oss/platformtest-account"
    service_name        = "account"
    service_db_password = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
    service_password    = "123-account-production"
  },
  #payment app
  {
    service_image       = "form3tech-oss/platformtest-payment"
    service_name        = "payment"
    service_db_password = "821462d7-47fb-402c-a22a-a58867602e39"
    service_password    = "123-payment-production"
  },
  #gateway app
  {
    service_image       = "form3tech-oss/platformtest-gateway"
    service_name        = "gateway"
    service_db_password = "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
    service_password    = "123-gateway-production"
  }
]


#Stage environment inputs
environment_inputs_stage = {
    env_name = "staging"
    nginx_port = 4082
    nginx_version = "latest"
    vault_address = "http://localhost:8401"
    vault_token = "f23612cf-824d-4206-9e94-e31a6dc8ee8e"
  }

#Stage services inputs
services_inputs_stage = [
  #account app
  {
    service_image       = "form3tech-oss/platformtest-account"
    service_name        = "account"
    service_db_password = "965d3c27-9e20-4d41-91c9-61e6631870e8"
    service_password    = "123-account-staging"
  },
  #payment app
  {
    service_image       = "form3tech-oss/platformtest-payment"
    service_name        = "payment"
    service_db_password = "a63e8938-6d49-49ea-905d-e03a683059e8"
    service_password    = "123-payment-staging"
  },
  #gateway app
  {
    service_image       = "form3tech-oss/platformtest-gateway"
    service_name        = "gateway"
    service_db_password = "10350819-4802-47ac-9476-6fa781e35cfa"
    service_password    = "123-gateway-staging"
  }
]