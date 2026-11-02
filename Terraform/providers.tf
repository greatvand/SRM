terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # 6.0 < version < 6.99
    }
  }
}

provider "aws" {
  region = var.aws_region
}