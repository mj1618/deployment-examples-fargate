terraform {
  backend remote {
    organization = "regchain-org"
    workspaces {
      prefix = "regchain-bastion-"
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
    organization = "regchain-org"
    workspaces = {
      name = local.vpc_workspace_name
    }
  }
}

data terraform_remote_state cluster {
  backend = "remote"
  config = {
    organization = "regchain-org"
    workspaces = {
      name = local.cluster_workspace_name
    }
  }
}

data aws_ecs_cluster main {
  cluster_name = data.terraform_remote_state.cluster.outputs.cluster_name
}
