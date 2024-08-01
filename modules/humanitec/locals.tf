locals {
  ingress_address = data.kubernetes_service.ingress_nginx_controller.status[0].load_balancer[0].ingress[0].hostname
  tags            = var.tags
}

