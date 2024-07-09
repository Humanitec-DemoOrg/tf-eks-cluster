
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain
  subject_alternative_names = var.domain_aliases
  validation_method         = "DNS"

  tags = {
    Name        = "ssl-${var.domain}"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_records : record.fqdn]
}


data "aws_route53_zone" "existing_zone" {
  name = var.domain
}

resource "aws_route53_record" "cert_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  records = [each.value.record]
  ttl     = 60
}
