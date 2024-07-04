output "oidc_issuer_url" {
  value = module.eks_bottlerocket.oidc_provider_arn
}