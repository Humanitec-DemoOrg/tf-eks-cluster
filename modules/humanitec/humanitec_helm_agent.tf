resource "helm_release" "humanitec_agent" {
  name             = "humanitec-agent"
  namespace        = "humanitec-agent"
  create_namespace = true
  repository       = "oci://ghcr.io/humanitec/charts"

  chart   = "humanitec-agent"
  version = "1.2.4"
  wait    = true
  timeout = 600

  set {
    name  = "humanitec.org"
    value = var.humanitec_org
  }

  set {
    name  = "humanitec.privateKey"
    value = file("humanitec_operator_agent_private_key.pem")
  }
}
