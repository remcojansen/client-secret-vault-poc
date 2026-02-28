terraform {
  required_version = ">= 1.7.0"

  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}
