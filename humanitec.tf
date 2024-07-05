resource "humanitec_resource_account" "aws-role" {
  id   = "humanitec-cloud-account-${local.environment}"
  name = "${local.environment} - Humanitec Cloud AWS"
  type = "aws-role"
  credentials = jsonencode({
    aws_role    = resource.aws_iam_role.humanitec_agent_policy.arn
    external_id = "${resource.random_id.external_id.id}"
  })
}

# Connect to an EKS cluster using dynamic credentials defined via a Cloud Account
resource "humanitec_resource_definition" "eks-dynamic-credentials" {
  id          = "eks-dynamic-credentials-${local.environment}"
  name        = "eks-dynamic-credentials-${local.environment}"
  type        = "k8s-cluster"
  driver_type = "humanitec/k8s-cluster-eks"
  # The driver_account is referring to a Cloud Account resource
  driver_account = humanitec_resource_account.aws-role.id

  driver_inputs = {
    values_string = jsonencode({
      "name"                     = "${local.name}"
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


# Ingress controller

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"

  chart   = "ingress-nginx"
  version = "4.10.1"
  wait    = true
  timeout = 600

  set {
    type  = "string"
    name  = "controller.replicaCount"
    value = var.ingress_nginx_replica_count
  }

  set {
    type  = "string"
    name  = "controller.minAvailable"
    value = var.ingress_nginx_min_unavailable
  }

  set {
    name  = "controller.containerSecurityContext.runAsUser"
    value = 101
  }

  set {
    name  = "controller.containerSecurityContext.runAsGroup"
    value = 101
  }

  set {
    name  = "controller.containerSecurityContext.allowPrivilegeEscalation"
    value = false
  }

  set {
    name  = "controller.containerSecurityContext.readOnlyRootFilesystem"
    value = false
  }

  set {
    name  = "controller.containerSecurityContext.runAsNonRoot"
    value = true
  }

  set_list {
    name  = "controller.containerSecurityContext.capabilities.drop"
    value = ["ALL"]
  }

  set_list {
    name  = "controller.containerSecurityContext.capabilities.add"
    value = ["NET_BIND_SERVICE"]
  }

  depends_on = [module.eks_bottlerocket.eks_managed_node_groups]
}