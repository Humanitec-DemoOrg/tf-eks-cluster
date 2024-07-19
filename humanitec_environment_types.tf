resource "humanitec_application" "newtrack" {
  id   = "anothertrack"
  name = "Another Track"
}

resource "humanitec_environment_type" "staging" {
  id          = "staging"
  description = "Environments used for automated staging."
}

resource "humanitec_environment_type" "production" {
  id          = "production"
  description = "Environments used for automated prod."
}

resource "humanitec_environment" "preprod" {
  app_id = humanitec_application.newtrack.id
  id     = "preprod"
  name   = "PreProd"
  type   = "staging"
}

resource "humanitec_environment" "prod" {
  app_id = humanitec_application.newtrack.id
  id     = "production"
  name   = "Production"
  type   = "production"
}