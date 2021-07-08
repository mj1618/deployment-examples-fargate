
locals {
  vpc_workspace_name = "dxfar-vpc-${terraform.workspace}"
  pg_workspace_name = "dxfar-pg-${terraform.workspace}"
  ecr_workspace_name = "dxfar-ecr"
  app_name = "app"
  session_ssm_name = "dxfar-session-ssm-${terraform.workspace}"
  domain_name = {
    dev = "app.dev.${var.dx_root_domain}"
    prod = "app.${var.dx_root_domain}"
  }[terraform.workspace]
  zone_name = var.dx_root_domain
  node_env = {
    dev = "development"
    prod = "production"
  }[terraform.workspace]
  app_port = 8080
}