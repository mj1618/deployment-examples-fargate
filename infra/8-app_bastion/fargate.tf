
### ECS

resource "aws_cloudwatch_log_group" "logs" {
  name = local.logs_name
  tags = {
    Env = terraform.workspace
  }
  retention_in_days = 30
}

locals {
  container_definition = {
    cpu         = local.fargate_cpu,
    image       = "amazonlinux:latest",
    memory      = local.fargate_memory,
    name        = local.fargate_app_name,
    networkMode = "awsvpc",
    environment = []
    secrets     = []
    command     = ["sleep", "3600"]
    linux_parameters = {
      initProcessEnabled = true
    }
    healthCheck = {
      command     = ["CMD-SHELL", "echo OK || exit 1"],
      startPeriod = 20
    },
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = local.logs_name,
        awslogs-region        = "ap-southeast-2",
        awslogs-stream-prefix = "ecs"
      }
    }
  }
}

data "aws_iam_policy_document" "task_role_policy" {
  statement {
    actions = ["sts:AssumeRole", ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = local.task_role_name
  assume_role_policy = data.aws_iam_policy_document.task_role_policy.json
}

resource "aws_iam_policy" "ssm_policy" {

  name = "systems_manager_policy"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_ecs_task_definition" "main" {
  family                   = local.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.fargate_cpu
  memory                   = local.fargate_memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = data.terraform_remote_state.cluster.outputs.ecs_task_execution_role_arn
  container_definitions    = jsonencode([local.container_definition])
}

resource "aws_ecs_service" "main" {
  name                   = local.ecs_service_name
  cluster                = data.aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.main.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    security_groups = [data.aws_security_group.ecs_tasks.id]
    subnets         = data.terraform_remote_state.vpc.outputs.vpc.private_subnets
  }
}
