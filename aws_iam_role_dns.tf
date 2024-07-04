resource "aws_iam_role" "external_dns_controller_role" {
  name = "AllowExternalDNSUpdatesRole-${local.environment}"
  tags = module.tags.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${module.eks_bottlerocket.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}:aud": "sts.amazonaws.com",
          "oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}:sub": "system:serviceaccount:external-dns:external-dns"
        }
      }
    }
  ]
}
EOF
}
