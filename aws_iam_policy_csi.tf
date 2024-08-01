resource "aws_iam_policy" "CSICreateVolume" {
  name        = "CSICreateVolume-${local.environment}"
  description = "Policy for CSI to Create Volume"
  tags        = module.tags.tags
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:AttachVolume",
                "ec2:DeleteVolume"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
