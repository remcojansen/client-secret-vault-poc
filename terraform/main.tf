locals {
  config_dir = abspath(var.client_config_dir)
  config_files = sort(distinct(concat(
    tolist(fileset(local.config_dir, "*.yaml")),
    tolist(fileset(local.config_dir, "*.yml"))
  )))

  client_docs = {
    for file_name in local.config_files :
    file_name => yamldecode(file("${local.config_dir}/${file_name}"))
  }

  clients = {
    for _, doc in local.client_docs :
    doc.client.client_id => doc.client
  }

  secret_paths = {
    for client_id, _ in local.clients :
    client_id => coalesce(
      lookup(var.vault_client_secret_paths, client_id, null),
      "keycloak/${client_id}"
    )
  }
}

resource "keycloak_realm" "poc" {
  realm   = var.realm
  enabled = true
}

module "client" {
  for_each = local.clients

  source = "./modules/keycloak-client"

  realm_id          = keycloak_realm.poc.id
  client            = each.value
  vault_kv_mount    = var.vault_kv_mount
  vault_secret_path = local.secret_paths[each.key]
}
