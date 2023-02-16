# Create kv-policy policy in the root namespace
resource "vault_policy" "k8s_policy" {
  name      = "policy"
  policy    = file("k8s-policy.hcl")
  namespace = vault_namespace.kunde1.path
}

