
### ECS

resource aws_cloudwatch_log_group logs {
  name              = local.logs_name
  tags              = {
    Env = var.environment
  }
  retention_in_days = 30
}

locals {
  container_definition = {
    cpu = var.fargate_cpu,
    image = var.ecr_url,
    memory = var.fargate_memory,
    name = local.fargate_app_name,
    networkMode = "awsvpc",
    environment = var.environment_variables
    secrets = var.environment_secrets
    portMappings = [
      {
        containerPort = var.fargate_app_port,
        hostPort = var.fargate_app_port
      }
    ],
    healthCheck = {
      command = [ "CMD-SHELL", "echo OK || exit 1" ],
      startPeriod = 20
    },
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group = local.logs_name,
        awslogs-region = "ap-southeast-2",
        awslogs-stream-prefix = "ecs"
      }
    }
  }
}

resource aws_ecs_task_definition main {
  family                   = local.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = data.terraform_remote_state.cluster.outputs.ecs_task_execution_role_arn
  container_definitions    = jsonencode([local.container_definition])
}

resource aws_ecs_service main {
  name            = local.ecs_service_name
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.fargate_app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [data.aws_security_group.ecs_tasks.id]
    subnets         = data.terraform_remote_state.vpc.outputs.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = local.fargate_app_name
    container_port   = var.fargate_app_port
  }
  
  depends_on = [
    aws_alb_listener.front_end_http,
    aws_alb_listener.front_end_https,
  ]
  
}
