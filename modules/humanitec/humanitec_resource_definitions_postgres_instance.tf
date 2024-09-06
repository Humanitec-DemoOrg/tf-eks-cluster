resource "humanitec_resource_definition" "postgres_instance" {
  driver_type = "humanitec/terraform"
  id          = "rds-shared-instance"
  name        = "rds-shared-instance"
  type        = "postgres-instance"

  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      source = {
        path = "modules/rds/basic_instance"
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

        prefix                                = var.prefix
        name                                  = "dbname10"
        database_name                         = "dbname10"
        create_db_subnet_group                = true
        db_subnet_group_name                  = "$${context.app.id}$${context.env.id}"
        subnet_ids                            = var.subnet_ids
        vpc_security_group_ids                = var.vpc_security_group_ids
        port                                  = var.port
        engine                                = var.engine
        engine_version                        = var.engine_version
        major_engine_version                  = var.major_engine_version
        group_family                          = var.group_family
        instance_class                        = var.instance_class
        allocated_storage                     = var.allocated_storage
        max_allocated_storage                 = var.max_allocated_storage
        multi_az                              = var.multi_az
        maintenance_window                    = var.maintenance_window
        backup_window                         = var.backup_window
        backup_retention_period               = var.backup_retention_period
        create_cloudwatch_log_group           = var.create_cloudwatch_log_group
        enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
        skip_final_snapshot                   = var.skip_final_snapshot
        deletion_protection                   = var.deletion_protection
        performance_insights_enabled          = var.performance_insights_enabled
        performance_insights_retention_period = var.performance_insights_retention_period
        create_monitoring_role                = var.create_monitoring_role
        monitoring_interval                   = var.monitoring_interval
        monitoring_role_name                  = var.monitoring_role_name
        monitoring_role_use_name_prefix       = var.monitoring_role_use_name_prefix
        monitoring_role_description           = var.monitoring_role_description
        parameters                            = var.parameters
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "postgres-development" {
  resource_definition_id = humanitec_resource_definition.postgres_instance.id
  env_type               = "development"
}
