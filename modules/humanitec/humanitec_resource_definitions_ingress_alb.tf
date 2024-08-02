resource "humanitec_resource_definition" "ingress_alb" {
  count       = var.loadbalancer_class == "alb" ? 1 : 0
  id          = "${var.environment}-ingress-alb"
  name        = "${var.environment}-ingress-alb"
  type        = "ingress"
  driver_type = "humanitec/ingress"

  driver_inputs = {
    values_string = jsonencode({
      "annotations" : {
        "alb.ingress.kubernetes.io/certificate-arn" : "${var.domain_cert_arn}",
        "alb.ingress.kubernetes.io/group.name" : "humanitec-ingress-group",
        "alb.ingress.kubernetes.io/listen-ports" : "[{\"HTTP\":80},{\"HTTPS\":443}]",
        "alb.ingress.kubernetes.io/scheme" : "internet-facing",
        "alb.ingress.kubernetes.io/ssl-redirect" : "443",
        "alb.ingress.kubernetes.io/target-type" : "ip"
      },
      "class" : "alb",
      "no_tls" : true
    })
  }
}

resource "humanitec_resource_definition_criteria" "ingress-alb-development" {
  count                  = var.loadbalancer_class == "alb" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.ingress_alb.0.id
  env_type               = "development"
}

resource "humanitec_resource_definition_criteria" "ingress-alb-staging" {
  count                  = var.loadbalancer_class == "alb" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.ingress_alb.0.id
  env_type               = "staging"
}

resource "humanitec_resource_definition_criteria" "ingress-alb-production" {
  count                  = var.loadbalancer_class == "alb" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.ingress_alb.0.id
  env_type               = "production"
}