resource "aws_iam_role" "humanitec_agent_policy" {
  name               = "HumanitecAgentPolicy-${var.environment}"
  tags               = local.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::767398028804:user/humanitec"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${resource.random_id.external_id.id}"
        }
      }
    }
  ]
}
EOF
}
