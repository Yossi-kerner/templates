terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = "http://ab2fe5d8c6c3642cf893184fc93d6be7-1541439417.us-east-1.elb.amazonaws.com:8200"
}

data "vault_kv_secret" "myapp_config" {
  path  = "secrets-for-env0/creds"
}

output "myapp_password" {
  value = data.vault_kv_secret.myapp_config.data["passcode"]
}
