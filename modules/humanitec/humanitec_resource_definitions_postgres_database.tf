resource "humanitec_resource_definition" "postgres_database" {
  driver_type = "humanitec/terraform"
  id          = "${var.prefix}rds-database"
  name        = "${var.prefix}rds-database"
  type        = "postgres"

  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      source = {
        path = "modules/rds/basic_postgres_database"
        rev  = "refs/heads/wip-database-changes"
        url  = "https://github.com/humanitec-architecture/resource-packs-aws.git"
      }

      append_logs_to_error = var.append_logs_to_error

      credentials_config = {
        environment = {
          AWS_ACCESS_KEY_ID     = "AccessKeyId"
          AWS_SECRET_ACCESS_KEY = "SecretAccessKey"
          AWS_SESSION_TOKEN     = "SessionToken"
        }
      }

      variables = {
        region = var.region
        res_id = "$${context.res.id}"
        app_id = "$${context.app.id}"
        env_id = "$${context.env.id}"

        database_name = "configfromscore"
        endpoint      = "$${resources['postgres-instance.default#rds-shared-instance'].outputs.host}"
        port          = "$${resources['postgres-instance.default#rds-shared-instance'].outputs.port}"
        username      = "$${resources['postgres-instance.default#rds-shared-instance'].outputs.username}"
        password      = "$${resources['postgres-instance.default#rds-shared-instance'].outputs.password}"

      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "postgres-database-development" {
  resource_definition_id = humanitec_resource_definition.postgres_database.id
  env_type               = "development"
}
