
resource aws_iam_role ecs_task_execution_role {
  name               = local.task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data aws_caller_identity current {}

data aws_iam_policy_document assume_role_policy {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource aws_iam_policy parameter_store_policy {
  name        = "parameter_store_policy"
  path        = "/"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "ssm:GetParameters"
        ],
        Resource: [
          "arn:aws:ssm:ap-southeast-2:${data.aws_caller_identity.current.account_id}:parameter/dx*"
        ]
      }
    ]
  })
}

resource aws_iam_role_policy_attachment execution_assume_role {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource aws_iam_role_policy_attachment execution_ssm {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.parameter_store_policy.arn
}
