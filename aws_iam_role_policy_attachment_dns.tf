resource "aws_iam_role_policy_attachment" "attach_dns_policy_to_role" {
  role       = aws_iam_role.external_dns_controller_role.name
  policy_arn = aws_iam_policy.AllowExternalDNSUpdatesPolicy.arn
}

