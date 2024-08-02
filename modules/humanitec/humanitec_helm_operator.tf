resource "helm_release" "humanitec_operator" {
  name             = "humanitec-operator"
  namespace        = "humanitec-operator-system"
  create_namespace = true
  repository       = "oci://ghcr.io/humanitec/charts"

  chart   = "humanitec-operator"
  version = "0.2.9"
  wait    = true
  timeout = 600
}