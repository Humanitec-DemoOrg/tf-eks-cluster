resource "aws_iam_policy" "humanitec-eks" {
  name        = "HumanitecEKS-${var.environment}"
  description = "Policy for Humanitec Access to EKS"
  tags        = local.tags
  policy      = <<EOF
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
        "Resource": "${var.k8s_cluster_arn}"
      }
    ]
  }
  EOF
}
