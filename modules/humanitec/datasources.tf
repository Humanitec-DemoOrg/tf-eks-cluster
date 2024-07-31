resource "random_id" "external_id" {
  byte_length = 32
}

data "kubernetes_service" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [helm_release.ingress_nginx]
}

data "aws_elb_hosted_zone_id" "main" {}

data "aws_route53_zone" "dev_zone" {
  name = var.dev_domain
}

data "aws_route53_zone" "staging_zone" {
  name = var.staging_domain
}

data "aws_route53_zone" "prod_zone" {
  name = var.prod_domain
}