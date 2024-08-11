terraform {
  required_version = "1.8.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.51.0"
    }
  }

  # buckendの設定は別ファイルに記述し、gitignoreとする
}

provider "aws" {
  region = "ap-northeast-1"
}
