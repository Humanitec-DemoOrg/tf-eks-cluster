data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*private*"
  }
}

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

data "aws_route53_zone" "existing_zone" {
  name = var.domain
}