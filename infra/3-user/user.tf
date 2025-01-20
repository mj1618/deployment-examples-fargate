
resource aws_iam_user main {
  name = var.username
  tags = {
    Env = terraform.workspace
  }
}

resource aws_iam_user_policy main {
  user   = aws_iam_user.main.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Resource = "*",
        Effect = "Allow",
        Action = [
          "acm:*",
          "application-autoscaling:*",
          "autoscaling:*",
          "cloudfront:*",
          "cloudwatch:*",
          "ec2:*",
          "ec2messages:*",
          "ecr:*",
          "ecs:*",
          "elasticloadbalancing:*",
          "events:*",
          "kinesis:*",
          "kms:*",
          "lambda:*",
          "logs:*",
          "pi:*",
          "rds:*",
          "route53:*",
          "route53domains:*",
          "s3:*",
          "sns:*",
          "sqs:*",
          "ssm:*",
          "secretsmanager:*",
          "ssmmessages:*",
          "xray:*",
          "codedeploy:*"
        ]
      },
      {
        Resource = "*",
        Effect = "Allow",
        Action = [
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "iam:AddRoleToInstanceProfile",
          "iam:AttachRolePolicy",
          "iam:CreateInstanceProfile",
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:CreateRole",
          "iam:CreateServiceLinkedRole",
          "iam:DeleteInstanceProfile",
          "iam:DeletePolicy",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DeleteServiceLinkedRole",
          "iam:DetachRolePolicy",
          "iam:GetInstanceProfile",
          "iam:GetUser",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:GetServiceLinkedRoleDeletionStatus",
          "iam:ListAttachedRolePolicies",
          "iam:ListEntitiesForPolicy",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfilesForRole",
          "iam:ListPolicies",
          "iam:ListPoliciesGrantingServiceAccess",
          "iam:ListPolicyVersions",
          "iam:ListRolePolicies",
          "iam:ListRoles",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:UpdateRole",
          "iam:UpdateRoleDescription",
          "iam:TagRole",
          "iam:DeletePolicyVersion"
        ]
      }
    ]
  })
}

resource aws_iam_access_key main {
  user = aws_iam_user.main.name
}