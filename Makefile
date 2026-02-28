.SILENT:

.PHONY: up
up:
	bash ./scripts/generate-cert.sh
	docker compose up -d
	bash ./scripts/wait-for-local-vault.sh
	bash ./scripts/wait-for-local-keycloak.sh
	bash ./scripts/vault-init.sh

.PHONY: config
config:
	cd terraform && terraform init && terraform apply

.PHONY: down
down:
	docker compose down

.PHONY: clean
clean:
	docker compose down -v
	rm -rf certs terraform/.terraform terraform/.terraform.lock.hcl terraform/terraform.tfstate terraform/terraform.tfstate.backup terraform/*.tfstate terraform/*.tfstate.* terraform/*.tfplan

.PHONY: help
.DEFAULT_GOAL := help

help:
	echo "Available targets:"
	echo "  make up      - Start containers and seed Vault"
	echo "  make config  - Apply Terraform configuration"
	echo "  make down    - Stop and remove containers"
	echo "  make clean   - Remove compose containers and terraform local state/artifacts"
