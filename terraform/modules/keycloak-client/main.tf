locals {
  grants  = toset(var.client.grant_types)
  replies = toset(var.client.response_types)

  token_auth_map = {
    client_secret_basic = "client-secret"
    client_secret_post  = "client-secret"
    private_key_jwt     = "client-jwt"
  }

  is_confidential = var.client.client_type == "confidential"
  client_authenticator_type = local.is_confidential ? lookup(
    local.token_auth_map,
    var.client.token_endpoint_auth_method,
    "client-secret"
  ) : null
}

data "vault_kv_secret_v2" "client_secret" {
  count = local.is_confidential ? 1 : 0

  mount = var.vault_kv_mount
  name  = var.vault_secret_path
}

resource "keycloak_openid_client" "client" {
  realm_id    = var.realm_id
  client_id   = var.client.client_id
  name        = var.client.client_name
  description = var.client.description
  enabled     = var.client.enabled

  access_type = local.is_confidential ? "CONFIDENTIAL" : "PUBLIC"

  valid_redirect_uris = var.client.redirect_uris

  standard_flow_enabled        = contains(local.grants, "authorization_code")
  implicit_flow_enabled        = contains(local.grants, "implicit")
  direct_access_grants_enabled = contains(local.grants, "password")
  service_accounts_enabled     = contains(local.grants, "client_credentials")

  client_authenticator_type = local.client_authenticator_type

  client_secret = local.is_confidential ? data.vault_kv_secret_v2.client_secret[0].data["client_secret"] : null
}
