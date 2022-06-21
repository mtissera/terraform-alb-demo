terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "terraform-nimbux911"
  region  = "us-east-1"
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}