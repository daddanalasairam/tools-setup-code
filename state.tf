terraform {
  backend "s3" {
    bucket         = "my-terraform-state-sairam-2026"
    key            = "tools/terraform.tfstate"
    region         = "us-east-1"
  }
}