#provider "aws" {
#  region = var.aws_region[terraform.workspace]
#}
/*
terraform {
  backend "s3" {
    bucket         = "bny-multi-env-setup"
    key            = "envs/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = false
  }
}
*/
terraform {
  backend "local" {
    path = "local.tfstate"
  }
}