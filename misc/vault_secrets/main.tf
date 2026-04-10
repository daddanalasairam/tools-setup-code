terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "vault-secrets/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "vault" {
  address = "https://vault-internal.sairamdevops.online:8200"
  token = var.vault_token
  skip_tls_verify = true
}

variable "vault_token" {}

resource "vault_generic_secret" "roboshop-dev" {
  path = "roboshop-dev/frontend"

  data_json = <<EOT
{
  "foo":   "bar",
  "pizza": "cheese"
}
EOT
}