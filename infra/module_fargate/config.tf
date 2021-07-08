
locals {
  vpc_workspace_name = "dxfar-vpc-${var.environment}"
  pg_workspace_name = "dxfar-pg-${var.environment}"
  cluster_workspace_name = "dxfar-cluster-${var.environment}"
  lb_name = "dxfar-${var.app_name}-alb-${var.environment}"
  target_group_name = "dxfar-${var.app_name}-tg-${var.environment}"
  session_ssm_name = "dxfar-${var.app_name}-ssm-session-${var.environment}"
  logs_name = "/fargate/service/dxfar-${var.app_name}-${var.environment}"
  task_definition_name = "dxfar-task-${var.app_name}-${var.environment}"
  fargate_app_name = "dxfar-fargate-${var.app_name}-${var.environment}"
  ecs_service_name = "dxfar-ecs-svc-${var.app_name}-${var.environment}"
  discovery_service_name = "dxfar-discovery-${var.app_name}-${var.environment}"
  zone_name = var.dx_root_domain
}