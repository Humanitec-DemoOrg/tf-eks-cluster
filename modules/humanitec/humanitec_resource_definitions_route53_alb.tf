resource "humanitec_resource_definition" "dev_dns_alb" {
  count = var.loadbalancer_class == "alb" ? 1 : 0
  id    = "example-dns-${var.environment}-dev-alb"
  name  = "Bobby Example DNS Dev"
  type  = "dns"

  driver_type    = "humanitec/dns-aws-route53"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      domain         = var.dev_domain
      hosted_zone_id = data.aws_route53_zone.dev_zone.id
      template       = "$${context.app.id}-$${context.env.id}"
    })
  }

  provision = {
    ingress = {
      is_dependent = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "dev_dns_alb" {
  count                  = var.loadbalancer_class == "alb" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.dev_dns_alb.0.id
  env_type             = "development"
  force_delete           = true
}   