terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }

    humanitec = {
      source  = "humanitec/humanitec"
      version = "1.6.5"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "kubernetes" {
  host                   = var.k8s_cluster_endpoint
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.k8s_cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_cluster_endpoint
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.k8s_cluster_name]
    }
  }
}