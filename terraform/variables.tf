variable "keycloak_url" {
  type        = string
  description = "Base URL for Keycloak (e.g. https://localhost:9443)"
}

variable "keycloak_admin_user" {
  type        = string
  description = "Keycloak admin username"
}

variable "keycloak_admin_password" {
  type        = string
  description = "Keycloak admin password"
  sensitive   = true
}

variable "realm" {
  type        = string
  description = "Realm to create and manage"
  default     = "poc"
}

variable "client_config_dir" {
  type        = string
  description = "Directory containing YAML client configurations"
  default     = "../config"
}

variable "vault_addr" {
  type        = string
  description = "Vault base URL (e.g. http://localhost:9200)"
  default     = "http://localhost:9200"
}

variable "vault_token" {
  type        = string
  description = "Vault token for reading secrets"
  sensitive   = true
  default     = "root"
}

variable "vault_kv_mount" {
  type        = string
  description = "KV v2 mount name for Vault secrets"
  default     = "secret"
}

variable "vault_client_secret_paths" {
  type        = map(string)
  description = "Optional per-client Vault KV v2 secret paths; defaults to keycloak/<client_id>"
  default     = {}
}
