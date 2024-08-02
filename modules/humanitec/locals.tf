locals {
  ingress_address = var.loadbalancer_class == "nginx" ? data.kubernetes_service.ingress_nginx_controller.status[0].load_balancer[0].ingress[0].hostname : var.alb_controller_ingress_address
  tags            = var.tags
}
