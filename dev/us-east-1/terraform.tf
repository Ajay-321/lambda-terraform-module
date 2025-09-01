terraform {
  required_providers {
    aws = {
      version = "~> 6.0"
    }
  }

  required_version = "~> 1.12.0"
}
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::214408080534:role/ec2-ssm-role"
  }
}

