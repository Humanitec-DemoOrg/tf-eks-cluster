resource "aws_iam_policy" "AllowExternalDNSUpdatesPolicy" {
  name        = "AllowExternalDNSUpdatesPolicy-${local.environment}"
  description = "Policy for AWS External DNS"
  tags        = module.tags.tags
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "route53:ChangeResourceRecordSets"
        ],
        "Resource": [
            "arn:aws:route53:::hostedzone/*"
        ]
        },
        {
        "Effect": "Allow",
        "Action": [
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets",
            "route53:ListTagsForResource"
        ],
        "Resource": [
            "*"
        ]
        }
    ]
}
EOF
}
