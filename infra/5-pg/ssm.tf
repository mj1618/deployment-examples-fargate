
resource random_password pg {
  length           = 32
  special          = true
}

resource aws_ssm_parameter db_password {
  name  = local.pg_password_name
  type  = "String"
  value = random_password.pg.result
}
