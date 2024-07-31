resource "humanitec_resource_definition" "s3_custom" {
  id   = "example-s3-custom-${var.environment}"
  name = "example-s3-custom-${var.environment}"
  type = "s3"

  driver_type    = "humanitec/s3"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      region = "eu-west-2"
    })
  }
}

resource "humanitec_resource_definition_criteria" "s3_custom" {
  resource_definition_id = humanitec_resource_definition.s3_custom.id
  env_id                 = "development"
  class                  = "custom"
  force_delete           = true
}