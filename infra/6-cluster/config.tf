
locals {
  vpc_workspace_name = "dxfar-vpc-${terraform.workspace}"
  cluster_name = "dxfar-cluster-${terraform.workspace}"
  task_execution_role_name = "dxfar-execution-role-${terraform.workspace}"
  lb_sg_name = "dxfar-lb-sg-${terraform.workspace}"
  ecs_tasks_sg_name = "dxfar-ecs-task-sg-${terraform.workspace}" 
}