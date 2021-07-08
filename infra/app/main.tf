terraform {
  backend remote {
    organization = "dxfar-org"
    workspaces {
      prefix = "dxfar-app-"
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

data terraform_remote_state pg {
  backend = "remote"
  config = {
    organization = "dxfar-org"
    workspaces = {
      name = local.pg_workspace_name
    }
  }
}

data terraform_remote_state ecr {
  backend = "remote"
  config = {
    organization = "dxfar-org"
    workspaces = {
      name = local.ecr_workspace_name
    }
  }
}

resource random_password session_secret {
  length           = 32
  special          = true
}

resource aws_ssm_parameter session_secret {
  name  = local.session_ssm_name
  type  = "String"
  value = random_password.session_secret.result
}

module app_fargate {
  source = "../module_fargate"
  ecr_url = data.terraform_remote_state.ecr.outputs.repository_url
  environment = terraform.workspace
  app_name = local.app_name
  domain_name = local.domain_name
  fargate_app_port = 8080
  dx_root_domain = var.dx_root_domain
  environment_variables = [
    { 
      name = "DB_USERNAME", 
      value = data.terraform_remote_state.pg.outputs.pg.rds_cluster_master_username
    },
    {
      name = "DB_HOST", 
      value = data.terraform_remote_state.pg.outputs.pg.rds_cluster_endpoint
    },
    {
      name = "DB_READ_HOST", 
      value = data.terraform_remote_state.pg.outputs.pg.rds_cluster_reader_endpoint
    },
    {
      name = "NODE_ENV", 
      value = local.node_env
    }
  ]
  environment_secrets = [
    {
      name= "DB_PASSWORD", 
      valueFrom = data.terraform_remote_state.pg.outputs.ssm_pg_pwd_arn
    },
    {
      name = "SESSION_SECRET", 
      valueFrom = aws_ssm_parameter.session_secret.arn
    }
  ]
}
