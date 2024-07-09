resource "humanitec_resource_definition" "dns" {
  id   = "example-dns-${local.environment}"
  name = "Bobby Example DNS"
  type = "dns"

  driver_type    = "humanitec/dns-aws-route53"
  driver_account = "humanitec-cloud-account-${local.environment}"
  driver_inputs = {
    values_string = jsonencode({
      domain         = local.domain
      hosted_zone_id = data.aws_route53_zone.existing_zone.id
    })
  }

  provision = {
    ingress = {
      is_dependent = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "dns" {
  resource_definition_id = humanitec_resource_definition.dns.id
  env_id                 = "development"
  force_delete           = true
}

resource "humanitec_resource_class" "resource_class" {
  id            = "custom"
  resource_type = "dns"
  description   = "An example resource class"
}