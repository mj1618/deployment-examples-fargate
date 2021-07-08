
data aws_route53_zone main {
  name         = local.zone_name
  private_zone = false
}

resource aws_acm_certificate main {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource aws_route53_record cert_validation {
  name    = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.main.id
  records = [tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value]
  ttl     = 60

  depends_on = [
    aws_acm_certificate.main
  ]
}

resource aws_acm_certificate_validation main {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource aws_route53_record subdomain {
  name    = var.domain_name
  zone_id = data.aws_route53_zone.main.id
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}
