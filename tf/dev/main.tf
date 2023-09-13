terraform {
  required_version = ">= 1.0.7"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }

    vault = {
      version = "3.0.1"
    }
  }
}

provider "vault" {
  alias   = "vault_dev"
  address = "http://localhost:8201"
  token   = var.token
}

resource "vault_audit" "audit_dev" {
  provider = vault.vault_dev
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_dev" {
  provider = vault.vault_dev
  type     = "userpass"
}


resource "vault_generic_secret" "account_development" {
  for_each  = toset(var.user_names)
  provider  = vault.vault_dev
  path      = each.secret_path
  data_json = each.secret_data_json
}

resource "vault_policy" "account_development" {
  for_each = toset(var.user_names)
  provider = vault.vault_dev
  name     = each.policy_name
  policy   = each.policy
}

resource "vault_generic_endpoint" "account_development" {
  for_each             = toset(var.user_names)
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = each.endpoint_path
  ignore_absent_fields = each.endpoint_ignore_absent_fields
  data_json            = each.endpoint_data_json
}




# #####
# resource "vault_generic_secret" "account_development" {
#   provider = vault.vault_dev
#   path     = "secret/development/account"

#   data_json = <<EOT
# {
#   "db_user":   "account",
#   "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
# }
# EOT
# }

# resource "vault_policy" "account_development" {
#   provider = vault.vault_dev
#   name     = "account-development"

#   policy = <<EOT

# path "secret/data/development/account" {
#     capabilities = ["list", "read"]
# }

# EOT
# }

# resource "vault_generic_endpoint" "account_development" {
#   provider             = vault.vault_dev
#   depends_on           = [vault_auth_backend.userpass_dev]
#   path                 = "auth/userpass/users/account-development"
#   ignore_absent_fields = true

#   data_json = <<EOT
# {
#   "policies": ["account-development"],
#   "password": "123-account-development"
# }
# EOT
# }
# #####

#####

# resource "vault_generic_secret" "gateway_development" {
#   provider = vault.vault_dev
#   path     = "secret/development/gateway"

#   data_json = <<EOT
# {
#   "db_user":   "gateway",
#   "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
# }
# EOT
# }

# resource "vault_policy" "gateway_development" {
#   provider = vault.vault_dev
#   name     = "gateway-development"

#   policy = <<EOT

# path "secret/data/development/gateway" {
#     capabilities = ["list", "read"]
# }

# EOT
# }

# resource "vault_generic_endpoint" "gateway_development" {
#   provider             = vault.vault_dev
#   depends_on           = [vault_auth_backend.userpass_dev]
#   path                 = "auth/userpass/users/gateway-development"
#   ignore_absent_fields = true

#   data_json = <<EOT
# {
#   "policies": ["gateway-development"],
#   "password": "123-gateway-development"
# }
# EOT
# }
# resource "vault_generic_secret" "payment_development" {
#   provider = vault.vault_dev
#   path     = "secret/development/payment"

#   data_json = <<EOT
# {
#   "db_user":   "payment",
#   "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
# }
# EOT
# }

# resource "vault_policy" "payment_development" {
#   provider = vault.vault_dev
#   name     = "payment-development"

#   policy = <<EOT

# path "secret/data/development/payment" {
#     capabilities = ["list", "read"]
# }

# EOT
# }

# resource "vault_generic_endpoint" "payment_development" {
#   provider             = vault.vault_dev
#   depends_on           = [vault_auth_backend.userpass_dev]
#   path                 = "auth/userpass/users/payment-development"
#   ignore_absent_fields = true

#   data_json = <<EOT
# {
#   "policies": ["payment-development"],
#   "password": "123-payment-development"
# }
# EOT
# }

resource "docker_container" "account_development" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=account-development",
    "VAULT_PASSWORD=123-account-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_development" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=gateway-development",
    "VAULT_PASSWORD=123-gateway-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment_development" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=payment-development",
    "VAULT_PASSWORD=123-payment-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "frontend_development" {
  image = "docker.io/nginx:latest"
  name  = "frontend_development"

  ports {
    internal = 80
    external = 4080
  }

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}
