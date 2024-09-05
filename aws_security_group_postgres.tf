resource "aws_security_group" "postgres" {
  name        = "postgres"
  description = "postgres"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "k8s_node_postgres" {
  security_group_id = aws_security_group.postgres.id

  referenced_security_group_id = module.eks_bottlerocket.node_security_group_id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}