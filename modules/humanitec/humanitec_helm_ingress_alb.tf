resource "helm_release" "aws_load_balancer_controller" {
  count            = var.loadbalancer_class == "alb" ? 1 : 0
  name             = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = false
  repository       = "https://aws.github.io/eks-charts"

  chart   = "aws-load-balancer-controller"
  version = "1.4.5" # Ensure this is the latest version
  wait    = true
  timeout = 600

  set {
    name  = "clusterName"
    value = var.k8s_cluster_name
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  # Add any additional configurations as needed
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {
  count = var.loadbalancer_class == "alb" ? 1 : 0
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
    }
  }
}