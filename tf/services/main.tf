resource "vault_audit" "audit" {
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass" {
  type     = "userpass"
}