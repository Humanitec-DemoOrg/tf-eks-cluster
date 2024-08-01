module "tags" {
  source  = "clowdhaus/tags/aws"
  version = "~> 1.0"

  application = var.cluster_name
  environment = local.environment
  repository  = "https://github.com/clowdhaus/eks-reference-architecture"
}
