provider "vault" {
  alias   = "stage"
  address = var.vault_address
  token   = var.vault_token
}