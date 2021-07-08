
output cluster_name {
  value = aws_ecs_cluster.main.name
}

output lb_sg_name {
  value = aws_security_group.lb.name
}

output ecs_tasks_sg_name {
  value = aws_security_group.ecs_tasks.name
}

output ecs_task_execution_role_arn {
  value = aws_iam_role.ecs_task_execution_role.arn
}