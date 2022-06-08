#   ___     _               __ _     _              __ _  
#  / __|   | |_    __ _    / _` |   (_)    _ _     / _` | 
#  \__ \   |  _|  / _` |   \__, |   | |   | ' \    \__, | 
#  |___/   _\__|  \__,_|   |___/   _|_|_  |_||_|   |___/  
#_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| 
#"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'
#Envorinment prefix
prefix = "stag"
environment = "staging"


#Vault variables
vault_port  = "8401"
vault_token = "f7777777-8888-4444-eeee-aaaaaaaaaaaa"

vault_internal_addr       = "http://vault-staging:8200"

vault_account_db_user     = "account"
vault_account_db_password = "aaaaaaaa-9e20-4d41-91c9-61e6631870e7"

vault_gateway_db_user     = "gateway"
vault_gateway_db_password = "bbbbbbbb-4802-47ac-9476-6fa781e35cfd"

vault_payment_db_user     = "payment"
vault_payment_db_password = "cccccccc-6d49-49ea-905d-e03a683059e7"

vault_account_ep_username = "account-staging"
vault_account_ep_password = "123-account-staging"
vault_gateway_ep_username = "gateway-staging"
vault_gateway_ep_password = "123-gateway-staging"
vault_payment_ep_username = "payment-staging"
vault_payment_ep_password = "123-payment-staging"


vault_policy_account_name = "account-staging"
vault_policy_gateway_name = "gateway-staging"
vault_policy_payment_name = "payment-staging"

#Service name
service_name_account = "account_staging"
service_name_gateway = "gateway_staging"
service_name_payment = "payment_staging"

#Networks
network_name = "vagrant_staging"

#environment as Path name
environment_path = "staging" 
