resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  description               = "Example transit secrets engine"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_transit_secret_backend_key" "key" {
  backend = vault_mount.transit.path
  name    = "my-key"
}

resource "vault_audit" "audit" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_pki_secret_backend_role" "role" {
  backend          = "pki_int"
  name             = "form3-interview-domains"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["form3interview.tech", "form3interview.com"]
  allow_subdomains = true
  key_usage = ["KeyUsageKeyEncipherment"]
}