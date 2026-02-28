variable "realm_id" {
  type        = string
  description = "Keycloak realm ID"
}

variable "client" {
  type = object({
    client_id                   = string
    client_name                 = string
    description                 = string
    redirect_uris               = list(string)
    response_types              = list(string)
    grant_types                 = list(string)
    token_endpoint_auth_method  = string
    enabled                     = bool
    client_type                 = string
  })
  description = "Client configuration loaded from YAML"
}

variable "vault_kv_mount" {
  type        = string
  description = "KV v2 mount name for Vault secrets"
}

variable "vault_secret_path" {
  type        = string
  description = "Vault KV v2 secret path containing client_secret"
}
