resource "humanitec_resource_account" "cloud_account" {
  id   = "ahumanitec-cloud-account-${var.environment}"
  name = "${var.environment} - Humanitec Cloud AWS"
  type = "aws-role"
  credentials = jsonencode({
    aws_role    = resource.aws_iam_role.humanitec_agent_policy.arn
    external_id = "${resource.random_id.external_id.id}"
  })
}

