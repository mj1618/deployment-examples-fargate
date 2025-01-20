
locals {
  vpc_workspace_name = "regchain-vpc-${terraform.workspace}"
  pg_workspace_name = "regchain-pg-${terraform.workspace}"
  cluster_workspace_name = "regchain-cluster-${terraform.workspace}"
  lb_name = "regchain-bastion-alb-${terraform.workspace}"
  target_group_name = "regchain-bastion-tg-${terraform.workspace}"
  session_ssm_name = "regchain-bastion-ssm-session-${terraform.workspace}"
  logs_name = "/fargate/service/regchain-bastion-${terraform.workspace}"
  task_definition_name = "regchain-task-bastion-${terraform.workspace}"
  fargate_app_name = "regchain-fargate-bastion-${terraform.workspace}"
  ecs_service_name = "regchain-ecs-svc-bastion-${terraform.workspace}"
  discovery_service_name = "regchain-discovery-bastion-${terraform.workspace}"
  task_role_name = "regchain-task-role-bastion-${terraform.workspace}"
  fargate_cpu=512
  fargate_memory=1024
}