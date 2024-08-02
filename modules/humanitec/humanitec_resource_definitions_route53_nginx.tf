resource "humanitec_resource_definition" "dev_dns_nginx" {
  count = var.loadbalancer_class == "nginx" ? 1 : 0
  id    = "example-dns-${var.environment}-dev-nginx"
  name  = "Bobby Example DNS Dev"
  type  = "dns"

  driver_type    = "humanitec/dns-aws-route53"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      domain         = var.dev_domain
      hosted_zone_id = data.aws_route53_zone.dev_zone.id
      template       = "$${context.app.id}"
    })
  }

  provision = {
    ingress = {
      is_dependent = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "dev_dns_nginx" {
  count                  = var.loadbalancer_class == "nginx" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.dev_dns_nginx.0.id
  env_id                 = "development"
  force_delete           = true
}

resource "humanitec_resource_definition" "staging_dns_nginx" {
  count = var.loadbalancer_class == "nginx" ? 1 : 0
  id    = "example-dns-${var.environment}-staging"
  name  = "Bobby Example DNS Staging"
  type  = "dns"

  driver_type    = "humanitec/dns-aws-route53"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      domain         = var.staging_domain
      hosted_zone_id = data.aws_route53_zone.staging_zone.id
      template       = "$${context.app.id}"
    })
  }

  provision = {
    ingress = {
      is_dependent = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "staging_dns_nginx" {
  count                  = var.loadbalancer_class == "nginx" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.staging_dns_nginx.0.id
  env_id                 = "preprod"
  force_delete           = true
}

resource "humanitec_resource_definition" "prod_dns_nginx" {
  count = var.loadbalancer_class == "nginx" ? 1 : 0
  id    = "example-dns-${var.environment}-prod"
  name  = "Bobby Example DNS Prod"
  type  = "dns"

  driver_type    = "humanitec/dns-aws-route53"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      domain         = var.prod_domain
      hosted_zone_id = data.aws_route53_zone.prod_zone.id
      template       = "$${context.app.id}"
    })
  }

  provision = {
    ingress = {
      is_dependent = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "prod_dns_nginx" {
  count                  = var.loadbalancer_class == "nginx" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.prod_dns_nginx.0.id
  env_type               = "production"
  force_delete           = true
}


resource "humanitec_resource_class" "resource_class" {
  count         = var.loadbalancer_class == "nginx" ? 1 : 0
  id            = "custom"
  resource_type = "dns"
  description   = "An example resource class"
}