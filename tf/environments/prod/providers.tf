provider "vault" {
  alias   = "prod"
  address = var.environment_inputs["vault_address"]
  token   = var.environment_inputs["vault_token"]
}