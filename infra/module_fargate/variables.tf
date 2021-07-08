variable ecr_url {
  description = "ecr repo name for the image to deploy"
}

variable domain_name {
  description = "full domain name, e.g. app.dev.dx_root_domain.com"
}

variable app_name {
  description = "name to use to differentiate conflicting resource names e.g. load balancers or security groups"
}

variable environment {
  description = "dev or prod"
}

variable environment_variables {
  description = "env vars to inject into the container"
  type = list(object({
    name = string
    value = string
  }))
}

variable environment_secrets {
  description = "env secrets to inject into the container"
}

variable fargate_cpu {
  default = 1024
}

variable fargate_memory {
  default = 2048
}

variable fargate_app_count {
  default = 1
}

variable fargate_app_port {}

variable dx_root_domain {}

