terraform {
  required_version = ">= 1.5.0"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "= 5.7.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0.0"
    }
  }
}

provider "keycloak" {
  client_id                = "admin-cli"
  url                      = var.keycloak_url
  username                 = var.keycloak_admin_user
  password                 = var.keycloak_admin_password
  realm                    = "master"
  tls_insecure_skip_verify = true
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}
