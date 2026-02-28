#!/usr/bin/env bash
set -euo pipefail

# Initialize Vault dev data for the POC.
# Requires: Vault container running and VAULT_TOKEN set (default: root).

export VAULT_ADDR="http://127.0.0.1:9200"
export VAULT_TOKEN="root"

# Store sample Keycloak client secrets.
vault kv put secret/keycloak/client1 client_secret="super-secret-client1"
vault kv put secret/keycloak/client2 client_secret="super-secret-client2"

echo "Seeded Vault at ${VAULT_ADDR} with client secrets for client1 and client2"
