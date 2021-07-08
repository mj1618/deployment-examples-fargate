terraform {
  required_providers {
    tfe = {
      version = "~> 0.25.0"
    }
  }
}

resource tfe_organization dxfar-org {
  name  = "dxfar-org"
  email = "admin@company.com"
}

variable workspace_prefixes {
  type        = list(string)
  default     = ["dxfar-vpc-", "dxfar-pg-", "dxfar-cluster-", "dxfar-app-"]
}

resource tfe_workspace dev {
  for_each = toset(var.workspace_prefixes)
  name         = "${each.value}dev"
  organization = tfe_organization.dxfar-org.id
  execution_mode = "local"
}

resource tfe_workspace prod {
  for_each = toset(var.workspace_prefixes)
  name         = "${each.value}prod"
  organization = tfe_organization.dxfar-org.id
  execution_mode = "local"
}

resource tfe_workspace ecr {
  name         = "dxfar-ecr"
  organization = tfe_organization.dxfar-org.id
  execution_mode = "local"
}

resource tfe_workspace user {
  name         = "dxfar-user"
  organization = tfe_organization.dxfar-org.id
  execution_mode = "local"
}
