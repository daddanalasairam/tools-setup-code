terraform {
  backend "s3" {
    bucket         = "aws-bucket11"
    key            = "tools/terraform.tfstate"
    region         = "us-east-1"
  }
}