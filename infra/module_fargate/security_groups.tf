
data aws_security_group lb {
  name        = data.terraform_remote_state.cluster.outputs.lb_sg_name
}

data aws_security_group ecs_tasks {
  name        = data.terraform_remote_state.cluster.outputs.ecs_tasks_sg_name
}
