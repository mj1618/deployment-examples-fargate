
output pg {
  value = module.pg
  sensitive = true
}

output ssm_pg_pwd_arn {
  value = aws_ssm_parameter.db_password.arn
}
