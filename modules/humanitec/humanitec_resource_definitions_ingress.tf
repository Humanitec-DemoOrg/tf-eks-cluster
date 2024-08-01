resource "humanitec_resource_definition" "ingress" {
  id          = "${var.environment}-ingress"
  name        = "${var.environment}-ingress"
  type        = "ingress"
  driver_type = "humanitec/ingress"

  driver_inputs = {
    values_string = jsonencode({
      "class" : "nginx",
      "no_tls" : true
    })
  }
}

resource "humanitec_resource_definition_criteria" "ingress-development" {
  resource_definition_id = humanitec_resource_definition.ingress.id
  env_type               = "development"
}

resource "humanitec_resource_definition_criteria" "ingress-staging" {
  resource_definition_id = humanitec_resource_definition.ingress.id
  env_type               = "staging"
}

resource "humanitec_resource_definition_criteria" "ingress-production" {
  resource_definition_id = humanitec_resource_definition.ingress.id
  env_type               = "production"
}