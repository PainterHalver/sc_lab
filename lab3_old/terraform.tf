terraform {
  required_version = ">= 1.7, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "starcamp-singapore-bucket"
    key            = "terraform/lab-3-jenkins/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "hiepdao-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}
