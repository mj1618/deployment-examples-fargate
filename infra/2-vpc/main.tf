terraform {
  backend "remote" {
    organization = "dxfar-org"
    workspaces {
      prefix = "dxfar-vpc-"

    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "deploymentuser"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = local.vpc_name

  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = terraform.workspace == "prod" ? false : true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Env = terraform.workspace
  }

  vpc_tags = {
    Env = terraform.workspace
  }
}
