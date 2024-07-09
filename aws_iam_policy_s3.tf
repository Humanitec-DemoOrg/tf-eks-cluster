resource "aws_iam_policy" "eks-access-s3" {
  name        = "EksS3Access-${local.environment}"
  description = "Policy for eks to Access s3"
  tags        = module.tags.tags
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
