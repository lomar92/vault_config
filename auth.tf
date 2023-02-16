#Configure Human Authentification
resource "vault_auth_backend" "userpass" {
  namespace = vault_namespace.kunde1.path
  type      = "userpass"
}

resource "vault_generic_endpoint" "u1" {
  namespace  = vault_namespace.kunde1.path
  depends_on = [vault_auth_backend.userpass]

  path                 = "auth/userpass/users/u1"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["user-policy"],
  "password": "password"
}
EOT
}


#Configure K8s Authentification
resource "vault_auth_backend" "kubernetes" {
  type      = "kubernetes"
  namespace = vault_namespace.kunde1.path
}

resource "vault_kubernetes_auth_backend_config" "example" {
  namespace = vault_namespace.kunde1.path

  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.k8s_url
  kubernetes_ca_cert     = var.SA_CA_CRT
  token_reviewer_jwt     = var.SA_JWT_TOKEN
  issuer                 = "api"
  disable_iss_validation = "true"
}

resource "vault_kubernetes_auth_backend_role" "example" {
  namespace = vault_namespace.kunde1.path

  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "my-role"
  bound_service_account_names      = ["webapp-sa"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.k8s_policy.name]
}