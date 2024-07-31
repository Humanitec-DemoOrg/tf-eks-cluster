resource "kubernetes_secret" "humanitec_operator" {
  metadata {
    name      = "humanitec-operator-private-key"
    namespace = helm_release.humanitec_operator.namespace
  }

  data = {
    privateKey              = file("humanitec_operator_agent_private_key.pem")
    humanitecOrganisationID = var.humanitec_org
  }
}

