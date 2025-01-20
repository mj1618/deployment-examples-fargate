terraform {
  backend remote {
    organization = "dxfar-org"
    workspaces {
      name = "dxfar-ecr"
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

provider aws {
  region = "ap-southeast-2"
  profile = "deploymentuser"
}

resource aws_ecr_repository app {
  name                 = local.app_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
