resource "aws_iam_policy" "humanitec-eks" {
  name        = "HumanitecEKS-${local.environment}"
  description = "Policy for Humanitec Access to EKS"
  tags = module.tags.tags
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:AccessKubernetesApi",
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        "Resource": "${module.eks_bottlerocket.cluster_arn}"
      }
    ]
  }
  EOF
}
