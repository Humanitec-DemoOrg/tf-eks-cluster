resource "humanitec_resource_definition" "s3_custom_terraform" {
  id   = "example-s3-custom-terraform-${var.environment}"
  name = "example-s3-custom-terraform-${var.environment}"
  type = "s3"

  driver_type    = "humanitec/terraform"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {

    values_string = jsonencode({

      credentials_config = {
        # Terraform script Variables. 
        variables = {
          ACCESS_KEY_ID     = "AccessKeyId"
          SECRET_ACCESS_KEY = "SecretAccessKey"
          SESSION_TOKEN     = "SessionToken"
        }

        # Environment Variables.
        environment = {
          AWS_ACCESS_KEY_ID     = "AccessKeyId"
          AWS_SECRET_ACCESS_KEY = "SecretAccessKey"
          AWS_SESSION_TOKEN     = "SessionToken"
        }
      }

      source = {
        path = "modules/s3/basic"
        rev  = "refs/heads/main"
        url  = "https://github.com/humanitec-architecture/resource-packs-aws.git"
      }

      variables = {
        region = var.region
        prefix = var.environment

        res_id = "$${context.res.id}"
        app_id = "$${context.app.id}"
        env_id = "$${context.env.id}"
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "s3_custom_terraform" {
  resource_definition_id = humanitec_resource_definition.s3_custom_terraform.id
  env_id                 = "development"
  class                  = "custom-terraform"
  force_delete           = true
}

resource "humanitec_resource_definition_criteria" "s3_custom_terraform_preprod" {
  resource_definition_id = humanitec_resource_definition.s3_custom_terraform.id
  env_id                 = "preprod"
  class                  = "custom-terraform"
  force_delete           = true
}

resource "humanitec_resource_definition_criteria" "s3_custom_terraform_prod" {
  resource_definition_id = humanitec_resource_definition.s3_custom_terraform.id
  env_id                 = "production"
  class                  = "custom-terraform"
  force_delete           = true
}