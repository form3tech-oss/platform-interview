provider "vault" {
  address = "http://localhost:8301"
  token   = "083672fc-4471-4ec4-9b59-a285e463a973"
}

module "vault" {
  source            = "../modules"
  environment       = "staging"
  service           = "account"
  db_user           = "test"
  db_password       = "123"
  endpoint_password = "123"
}
