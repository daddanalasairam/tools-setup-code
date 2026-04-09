terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "tools/terraform.tfstate"
    region         = "us-east-1"
  }
}