resource "kubernetes_manifest" "bobby_secret_store" {
  manifest = {
    "apiVersion" = "humanitec.io/v1alpha1"
    "kind"       = "SecretStore"
    "metadata" = {
      "name"      = var.secret_store_name
      "namespace" = helm_release.humanitec_operator.namespace
      "labels" = {
        "app.humanitec.io/default-store" = "true"
      }
    }
    "spec" = {
      "awssm" = {
        "region" = "eu-west-2"
        "auth"   = {}
      }
    }
  }
}