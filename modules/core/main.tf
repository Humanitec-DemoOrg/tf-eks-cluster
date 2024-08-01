
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

# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation_records : record.fqdn]
# }




locals {
  # Create a map to group by resource_record_name
  grouped_domain_validation_options = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.resource_record_name => dvo...
  }

  # Convert the map to a list of unique domain validation options by picking the first item in each group
  unique_domain_validation_options = [
    for record_name, records in local.grouped_domain_validation_options : records[0]
  ]
}

data "aws_route53_zone" "existing_zone" {
  name = var.domain
}

data "aws_route53_zone" "existing_staging_zone" {
  name = "preprod.${var.domain}"
}

data "aws_route53_zone" "existing_dev_zone" {
  name = "dev.${var.domain}"
}


# resource "aws_route53_record" "cert_validation_records_dev" {
#   for_each = {
#     for dvo in local.unique_domain_validation_options : "${dvo.domain_name}_${dvo.resource_record_name}" => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   lifecycle {
#     ignore_changes = [records]
#   }

#   name    = each.value.name
#   type    = each.value.type
#   zone_id = data.aws_route53_zone.existing_dev_zone.zone_id
#   records = [each.value.record]
#   ttl     = 60
# }

# resource "aws_route53_record" "cert_validation_records_staging" {
#   for_each = {
#     for dvo in local.unique_domain_validation_options : "${dvo.domain_name}_${dvo.resource_record_name}" => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   lifecycle {
#     ignore_changes = [records]
#   }

#   name    = each.value.name
#   type    = each.value.type
#   zone_id = data.aws_route53_zone.existing_staging_zone.zone_id
#   records = [each.value.record]
#   ttl     = 60
# }

resource "aws_route53_record" "cert_validation_records_prod" {
  for_each = {
    for dvo in local.unique_domain_validation_options : "${dvo.domain_name}_${dvo.resource_record_name}" => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  lifecycle {
    ignore_changes = [records]
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  records = [each.value.record]
  ttl     = 60
}