terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "nazii"
    key = "terraform/lab-1/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}
