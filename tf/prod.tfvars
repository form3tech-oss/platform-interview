#    ____  ____  ____  ____  __  ______________________  _   __
#   / __ \/ __ \/ __ \/ __ \/ / / / ____/_  __/  _/ __ \/ | / /
#  / /_/ / /_/ / / / / / / / / / / /     / /  / // / / /  |/ / 
# / ____/ _, _/ /_/ / /_/ / /_/ / /___  / / _/ // /_/ / /|  /  
#/_/   /_/ |_|\____/_____/\____/\____/ /_/ /___/\____/_/ |_/   
#Envorinment prefix
prefix = "prod"
environment = "production"


#Vault variables
vault_port  = "8301"
vault_token = "083672fc-4471-4ec4-9b59-a285e463a973"

vault_internal_addr       = "http://vault-production:8200" 

vault_account_db_user     = "account"
vault_account_db_password = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"

vault_gateway_db_user     = "gateway"
vault_gateway_db_password = "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"

vault_payment_db_user     = "payment"
vault_payment_db_password = "821462d7-47fb-402c-a22a-a58867602e39"

vault_account_ep_username = "account-production"
vault_account_ep_password = "123-account-production"
vault_gateway_ep_username = "gateway-production"
vault_gateway_ep_password = "123-gateway-production"
vault_payment_ep_username = "payment-production"
vault_payment_ep_password = "123-payment-production"


vault_policy_account_name = "account-production"
vault_policy_gateway_name = "gateway-production"
vault_policy_payment_name = "payment-production"

#Service name
service_name_account = "account_production"
service_name_gateway = "gateway_production"
service_name_payment = "payment_production"

#Networks
network_name = "vagrant_production"

#environment as Path name
environment_path = "production" 
