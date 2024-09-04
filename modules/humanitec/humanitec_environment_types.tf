resource "humanitec_application" "newtrack" {
  id   = "track-api22"
  name = "track-api22"
}

resource "humanitec_environment_type" "staging" {
  id          = "staging"
  description = "Environments used for automated staging."
}

resource "humanitec_environment_type" "production" {
  id          = "production"
  description = "Environments used for automated prod."
}

# resource "humanitec_environment" "preprod" {
#   app_id = humanitec_application.newtrack.id
#   id     = "preprod"
#   name   = "PreProd"
#   type   = humanitec_environment_type.staging.id
# }

# resource "humanitec_environment" "prod" {
#   app_id = humanitec_application.newtrack.id
#   id     = "production"
#   name   = "Production"
#   type   = humanitec_environment_type.production.id
# }