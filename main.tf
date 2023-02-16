#------------------------------------------------------------------------------
# The best practice is to use remote state file and encrypt it since your
# state files may contains sensitive data (secrets).
#------------------------------------------------------------------------------

#terraform cloud backend:
terraform {
  cloud {
    organization = "lomar"
    workspaces {
      name = "vault_config"
    }
  }
  required_providers {
    vault = "~> 3.8.0"
  }
}

# Vault Provider 
provider "vault" {
  address         = var.address
  token           = var.token
  skip_tls_verify = true
}

resource "vault_namespace" "kunde1" {
  path = "kunde1"
}
