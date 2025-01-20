
locals {
  vpc_workspace_name     = "dxfar-vpc-${terraform.workspace}"
  pg_workspace_name      = "dxfar-pg-${terraform.workspace}"
  cluster_workspace_name = "dxfar-cluster-${terraform.workspace}"
  lb_name                = "dxfar-bastion-alb-${terraform.workspace}"
  target_group_name      = "dxfar-bastion-tg-${terraform.workspace}"
  session_ssm_name       = "dxfar-bastion-ssm-session-${terraform.workspace}"
  logs_name              = "/fargate/service/dxfar-bastion-${terraform.workspace}"
  task_definition_name   = "dxfar-task-bastion-${terraform.workspace}"
  fargate_app_name       = "dxfar-fargate-bastion-${terraform.workspace}"
  ecs_service_name       = "dxfar-ecs-svc-bastion-${terraform.workspace}"
  discovery_service_name = "dxfar-discovery-bastion-${terraform.workspace}"
  task_role_name         = "dxfar-task-role-bastion-${terraform.workspace}"
  fargate_cpu            = 512
  fargate_memory         = 1024
}
