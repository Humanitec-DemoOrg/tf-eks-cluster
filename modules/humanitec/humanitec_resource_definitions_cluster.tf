# Connect to an EKS cluster using dynamic credentials defined via a Cloud Account
resource "humanitec_resource_definition" "eks-dynamic-credentials" {
  id          = "eks-dynamic-credentials-${var.environment}"
  name        = "eks-dynamic-credentials-${var.environment}"
  type        = "k8s-cluster"
  driver_type = "humanitec/k8s-cluster-eks"
  # The driver_account is referring to a Cloud Account resource
  driver_account = humanitec_resource_account.cloud_account.id

  driver_inputs = {
    values_string = jsonencode({
      "name"                     = var.k8s_cluster_name
      "region"                   = var.region
      "loadbalancer"             = local.ingress_address
      "loadbalancer_hosted_zone" = data.aws_elb_hosted_zone_id.main.id
    })
  }
}

resource "humanitec_resource_definition_criteria" "eks-dynamic-credentials-matching" {
  resource_definition_id = humanitec_resource_definition.eks-dynamic-credentials.id
  env_type               = "development"
}

resource "humanitec_resource_definition_criteria" "eks-dynamic-credentials-matching_staging" {
  resource_definition_id = humanitec_resource_definition.eks-dynamic-credentials.id
  env_type               = "staging"
}

resource "humanitec_resource_definition_criteria" "eks-dynamic-credentials-matching_prod" {
  resource_definition_id = humanitec_resource_definition.eks-dynamic-credentials.id
  env_type               = "production"
}