


module "eks_bottlerocket" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                             = local.name
  cluster_version                          = "1.29"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true

      timeouts = {
        create = "25m"
        delete = "10m"
      }
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  vpc_id     = data.aws_vpc.selected.id
  subnet_ids = data.aws_subnets.private_subnets.ids

  eks_managed_node_groups = {
    bottlerocket = {
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      min_size     = 2
      max_size     = 3
      desired_size = 2

      iam_role_additional_policies = {
        CSICreateVolume = aws_iam_policy.CSICreateVolume.arn
      }
    }
  }

  enable_irsa = true

  access_entries = {
    for s in local.k8s_access_entries : s.id => {
      kubernetes_groups = []
      principal_arn     = s.principal_arn

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
  }

  tags = module.tags.tags
}

module "route53_core" {
  source         = "./modules/core"
  domain         = var.domain
  domain_aliases = var.domain_aliases
  environment    = local.environment
}
