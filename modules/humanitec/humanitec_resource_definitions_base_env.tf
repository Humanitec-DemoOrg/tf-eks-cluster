resource "humanitec_resource_definition" "pod_identity_base_env_terraform" {
  id   = "pod-identity-base-env-terraform-${var.environment}"
  name = "pod-identity-base-env-terraform-${var.environment}"
  type = "base-env"

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
        path = "pod-identity-association"
        rev  = "refs/heads/main"
        url  = "https://github.com/Humanitec-DemoOrg/tf-aws-modules.git"
      }

      variables = {
        region           = var.region
        k8s_cluster_name = var.k8s_cluster_name
        k8s_namespace    = "$${context.app.id}-$${context.env.id}"
        aws_iam_role_arn = "arn:aws:iam::211125452745:role/eks-pod-identity-example"

        res_id = "$${context.res.id}"
        app_id = "$${context.app.id}"
        env_id = "$${context.env.id}"
      }
    })
  }

}

resource "humanitec_resource_definition_criteria" "pod_identity_base_env_terraform" {
  resource_definition_id = humanitec_resource_definition.pod_identity_base_env_terraform.id
  env_id                 = "development"
  class                  = "default"
  force_delete           = true
}
