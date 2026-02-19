resource "aws_acm_certificate" "this" {
  domain_name       = "memos-app-ecs.com"
  validation_method = "DNS"
}

# Validation record in your existing zone
resource "aws_route53_record" "validation" {
  zone_id         = "Z0597504WBYW8GGB4VTX"
  name            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value]
  ttl             = 300
  allow_overwrite = true
}

# Certificate validation
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.validation.fqdn]
}


# DNS record pointing to ALB (in your existing zone)
resource "aws_route53_record" "app" {
  zone_id = "Z0597504WBYW8GGB4VTX"
  name    = "memos-app-ecs.com"
  type    = "A"
  alias {
    name                   = module.alb.frontend_alb_dns_name
    zone_id                = module.alb.frontend_alb_zone_id
    evaluate_target_health = true
  }
}
