provider "vault" {
  alias   = "dev"
  address = var.environment_inputs["vault_address"]
  token   = var.environment_inputs["vault_token"]
}