resource "humanitec_resource_definition" "s3" {
  id   = "example-s3-${local.environment}"
  name = "example-s3-${local.environment}"
  type = "s3"

  driver_type    = "humanitec/s3"
  driver_account = "humanitec-cloud-account-${local.environment}"
  driver_inputs = {
    values_string = jsonencode({
      region = "eu-west-2"
    })
  }
}

resource "humanitec_resource_definition_criteria" "s3" {
  resource_definition_id = humanitec_resource_definition.s3.id
  env_id                 = "development"
  force_delete           = true
}