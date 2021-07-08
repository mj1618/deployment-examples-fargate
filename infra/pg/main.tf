terraform {
  backend remote {
    organization = "dxfar-org"
    workspaces {
      prefix = "dxfar-pg-"
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

data terraform_remote_state vpc {
  backend = "remote"
  config = {
    organization = "dxfar-org"
    workspaces = {
      name = local.vpc_workspace_name
    }
  }
}
