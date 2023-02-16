resource "vault_mount" "kvv2" {
  namespace = vault_namespace.kunde1.path

  path        = "static-secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Test Path"
}

resource "vault_kv_secret_v2" "secret" {
  namespace = vault_namespace.kunde1.path


  mount               = vault_mount.kvv2.path
  name                = "db-secret"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      nutzername = "max",
      password   = "password"
    }
  )
}
