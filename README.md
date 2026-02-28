# Vault + Keycloak Terraform POC

This POC shows how to combine the Keycloak and Vault Terraform providers to provision Keycloak clients where each client secret is read from Vault. Client configuration is stored in YAML files under the config/ directory, and Terraform creates one Keycloak client per file.

## Prerequisites

- Docker and Docker Compose
- Terraform 1.5+
- Vault CLI (for ./scripts/vault-init.sh)

## Local setup

1. Start Keycloak and Vault, then seed Vault with secrets:

   ```sh
   make up
   ```

2. Apply Terraform to provision the Keycloak clients:

   ```sh
   make config
   ```

3. To stop and clean up:

   ```sh
   make down      # Stop containers
   make clean     # Remove containers, volumes, and Terraform state
   ```

## Available Make targets

- `make up` — Generate HTTPS certs, start Keycloak and Vault, wait for readiness, seed Vault with secrets
- `make config` — Initialize and apply Terraform configuration
- `make down` — Stop and remove containers
- `make clean` — Full cleanup (containers, volumes, Terraform state, certs)

## Configuration

- Client configs are loaded from the config/ directory.
- Each YAML file must include a top-level `client` object with the fields used by the module. For the YAML format, see https://github.com/remcojansen/oidc-client-migration/blob/main/oidcconfig/client_config.go.
- Vault secret paths default to `keycloak/<client_id>` and can be overridden via `vault_client_secret_paths` in terraform/terraform.tfvars.
- Public clients (for example client3) do not read a secret from Vault.

## Notes

- Keycloak admin UI: https://localhost:9443 (admin/admin)
- Vault dev UI: http://localhost:9200 (token: root)

## Known Issues & Future Work

**Partial YAML Field Coverage**

The YAML schema is broader than what this POC currently maps into Keycloak. Some fields present in the config files are intentionally ignored because the Terraform module only wires up a subset of client settings. Treat the YAML files as a shared schema rather than a guarantee that every field will be applied until the module is extended.

**Vault Provider Deprecation Warning**

The Terraform Vault provider emits a deprecation warning when applying:

```
Warning: Deprecated Resource - Please use new Ephemeral KVV2 Secret resource instead
data "vault_kv_secret_v2" "client_secret"
```

This warning occurs because Hashicorp recommends using ephemeral data sources for KV v2 secrets. However:
- Ephemeral values cannot be persisted to Terraform state
- The keycloak provider requires client secret persistence in state to manage Keycloak clients

**Future Enhancement: Keycloak Provider Support for Write-Only Secrets**

To fully align with Hashicorp's recommendation to use ephemeral sources for secrets, the keycloak Terraform provider should be updated to support write-only attributes for the `client_secret`. This would allow:
- Reading the secret from Vault using ephemeral data
- Passing it to keycloak as a sensitive, write-only input
- Preventing the secret from being persisted in Terraform state

This would require changes to the keycloak provider to mark the `client_secret` attribute as write-only and offer an alternative API for managing secrets externally.
