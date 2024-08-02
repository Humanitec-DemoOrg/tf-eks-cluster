resource "humanitec_resource_definition" "ingress_nginx" {
  count       = var.loadbalancer_class == "nginx" ? 1 : 0
  id          = "${var.environment}-ingress-nginx"
  name        = "${var.environment}-ingress-nginx"
  type        = "ingress"
  driver_type = "humanitec/ingress"

  driver_inputs = {
    values_string = jsonencode({
      "class" : "nginx",
      "no_tls" : true
    })
  }
}

resource "humanitec_resource_definition_criteria" "ingress-nginx-development" {
  count                  = var.loadbalancer_class == "nginx" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.ingress_nginx.0.id
  env_type               = "development"
}

resource "humanitec_resource_definition_criteria" "ingress-nginx-staging" {
  count                  = var.loadbalancer_class == "nginx" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.ingress_nginx.0.id
  env_type               = "staging"
}

resource "humanitec_resource_definition_criteria" "ingress-nginx-production" {
  count                  = var.loadbalancer_class == "nginx" ? 1 : 0
  resource_definition_id = humanitec_resource_definition.ingress_nginx.0.id
  env_type               = "production"
}