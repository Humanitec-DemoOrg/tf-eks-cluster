locals {

  region = var.region
  domain = var.domain

  environment = var.env
  default_k8s_access_entries = [
    {
      id            = module.humanitec.agent_policy_name
      principal_arn = module.humanitec.agent_policy_arn
      groups        = ["system:masters"]
    }
  ]
  //default_k8s_access_entries = []
  k8s_access_entries = local.default_k8s_access_entries
}

