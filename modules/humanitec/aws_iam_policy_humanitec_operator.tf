resource "aws_iam_policy" "humanitec-operator" {
  name        = "HumanitecOperator-${var.environment}"
  description = "Policy for Humanitec Operator to Access Secrets"
  tags        = local.tags
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
           "secretsmanager:GetSecretValue",
           "secretsmanager:CreateSecret",
           "secretsmanager:DeleteSecret",
           "secretsmanager:PutSecretValue",
           "secretsmanager:RestoreSecret"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}
