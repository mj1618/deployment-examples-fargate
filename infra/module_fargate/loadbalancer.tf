
resource aws_alb main {
  name            = local.lb_name
  subnets         = data.terraform_remote_state.vpc.outputs.vpc.public_subnets
  security_groups = [data.aws_security_group.lb.id]
}

resource aws_alb_target_group main {
  name        = local.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  target_type = "ip"
  health_check {
    path = "/healthcheck"
  }
}

# Redirect all traffic from the ALB to the target group
resource aws_alb_listener front_end_http {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect all traffic from the ALB to the target group
resource aws_alb_listener front_end_https {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.main.arn
  depends_on = [aws_alb_target_group.main]

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }

}
