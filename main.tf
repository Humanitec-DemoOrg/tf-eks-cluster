terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
   
  }
}

provider "aws" {
  region = "eu-west-2"
}


module "eks_bottlerocket" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name}"
  cluster_version = "1.29"
  cluster_endpoint_public_access = true
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

  tags = module.tags.tags
}

provider "kubernetes" {
  host                   = module.eks_bottlerocket.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_bottlerocket.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_bottlerocket.cluster_name]
  }
}

module "route53_core" {
  source = "./modules/core"
  domain = var.domain
  domain_aliases = var.domain_aliases
  environment = local.environment
}