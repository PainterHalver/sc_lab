terraform {
  required_version = ">= 1.7, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nazii"
    key            = "terraform/lab-3-jenkins/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "hiepdao-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}
