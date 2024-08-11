terraform {
  required_version = "1.8.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.51.0"
    }
  }

  # initial_setup/prod/terraform.tf で設定したbackendの設定を引き継ぐ
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
