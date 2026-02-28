#!/usr/bin/env bash

VAULT_HEALTH_URL="http://localhost:9200/v1/sys/health"

printf "Waiting for local Vault to be ready"

until $(curl --output /dev/null --silent --head --fail --max-time 2 ${VAULT_HEALTH_URL}); do
    printf '.'
    sleep 2
done

echo
