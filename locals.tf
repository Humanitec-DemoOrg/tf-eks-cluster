locals {
  name   = var.cluster_name
  region = var.region
  domain = var.domain

  dev_domain     = var.dev_domain
  staging_domain = var.staging_domain
  prod_domain    = var.prod_domain
  environment    = var.env
  default_k8s_access_entries = [
    {
      id            = aws_iam_role.humanitec_agent_policy.name
      principal_arn = aws_iam_role.humanitec_agent_policy.arn
      groups        = ["system:masters"]
    }
  ]
  k8s_access_entries = local.default_k8s_access_entries
}

locals {
  ingress_address = data.kubernetes_service.ingress_nginx_controller.status[0].load_balancer[0].ingress[0].hostname
}

