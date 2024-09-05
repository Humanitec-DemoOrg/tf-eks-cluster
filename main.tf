


module "eks_bottlerocket" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                             = var.cluster_name
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
  domain         = var.prod_domain
  domain_aliases = var.domain_aliases
  environment    = local.environment
}

module "humanitec" {
  source                         = "./modules/humanitec"
  humanitec_org                  = var.humanitec_org
  environment                    = local.environment
  k8s_cluster_name               = module.eks_bottlerocket.cluster_name
  k8s_cluster_endpoint           = module.eks_bottlerocket.cluster_endpoint
  k8s_cluster_arn                = module.eks_bottlerocket.cluster_arn
  k8s_cluster_ca_certificate     = module.eks_bottlerocket.cluster_certificate_authority_data
  loadbalancer_class             = "alb"
  alb_controller_ingress_address = "dualstack.k8s-humanitecingressg-6302cffcc2-1760327061.eu-west-2.elb.amazonaws.com"
  alb_controller_role_arn        = aws_iam_role.eks_load_balancer_controller_role.arn
  tags                           = module.tags.tags
  region                         = var.region
  secret_store_name              = var.secret_store_name
  domain_cert_arn                = module.route53_core.cert_arn
  prod_domain                    = var.prod_domain
  staging_domain                 = var.staging_domain
  dev_domain                     = var.dev_domain
  subnet_ids                     = data.aws_subnets.private_subnets.ids
  vpc_security_group_ids         = [aws_security_group.postgres.id]
}
