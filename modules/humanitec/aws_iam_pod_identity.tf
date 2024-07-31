data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}


resource "aws_iam_role" "example" {
  name               = "eks-pod-identity-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example_s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.example.name
}



resource "aws_eks_pod_identity_association" "association" {
  for_each        = toset(var.environments)
  cluster_name    = var.k8s_cluster_name
  namespace       = "${humanitec_application.newtrack.id}-${each.value}"
  service_account = "default"
  role_arn        = aws_iam_role.example.arn
}


## Operator Secret stuff

resource "aws_iam_role_policy_attachment" "attach_operator_policy_to_role" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.humanitec-operator.arn
}

# resource "aws_iam_role_policy_attachment" "attach_admin_eks_policy_to_operator_role" {
#   role       = aws_iam_role.example.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

resource "aws_eks_pod_identity_association" "operator_association" {
  cluster_name    = var.k8s_cluster_name
  namespace       = helm_release.humanitec_operator.namespace
  service_account = "humanitec-operator-controller-manager"
  role_arn        = aws_iam_role.example.arn
}

