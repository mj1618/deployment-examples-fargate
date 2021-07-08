locals {
  vpc_workspace_name = "dxfar-vpc-${terraform.workspace}"
  pg_workspace_name = "dxfar-pg-${terraform.workspace}"
  pg_identifier = "dxfar-pg-${terraform.workspace}"
  pg_name = "dxfarpg${terraform.workspace}"
  pg_sg_name = "dxfar-pg-sg-${terraform.workspace}"
  pg_password_name = "dxfar-pg-pwd-${terraform.workspace}"
  db_cluster_param_group_name = "dxfar-cluster-params-${terraform.workspace}"
  db_param_group_name = "dxfar-pg-params-${terraform.workspace}"
}