
resource aws_security_group pg_sg {
  name        = local.pg_sg_name
  description = "Allow db ingress/egress"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env = terraform.workspace
  }
}

resource aws_db_parameter_group main {
  name   = local.db_param_group_name
  family = "aurora-postgresql12"
}

resource aws_rds_cluster_parameter_group main {
  name        = local.db_cluster_param_group_name
  family      = "aurora-postgresql12"
  description = "RDS default cluster parameter group"
}

module pg {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "5.2.0"

  name           = local.pg_name
  engine         = "aurora-postgresql"
  engine_version = "12.6"
  instance_type  = "db.t3.medium"

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  subnets = data.terraform_remote_state.vpc.outputs.vpc.private_subnets

  replica_count           = 1
  allowed_security_groups = [aws_security_group.pg_sg.id]
  # allowed_cidr_blocks     = ["0.0.0.0/0"]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = local.db_param_group_name
  db_cluster_parameter_group_name = local.db_cluster_param_group_name

  password = random_password.pg.result
  create_random_password = false

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Env = terraform.workspace
  }
}
