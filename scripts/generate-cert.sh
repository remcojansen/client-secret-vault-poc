#!/bin/bash

# Generate self-signed certificate for Keycloak dev mode
CERT_DIR="certs"

if [ -f "$CERT_DIR/server.crt" ]; then
  echo "Certificate already exists at $CERT_DIR/server.crt"
  exit 0
fi

mkdir -p "$CERT_DIR"

openssl req -x509 -newkey rsa:2048 -keyout "$CERT_DIR/server.key" -out "$CERT_DIR/server.crt" \
  -days 365 -nodes \
  -subj "/CN=localhost/O=Vault POC/C=US"

echo "✓ Self-signed certificate generated at $CERT_DIR/"
