
output secret {
  sensitive = true
  value = aws_iam_access_key.main.secret
}

output id {
  value = aws_iam_access_key.main.id
}