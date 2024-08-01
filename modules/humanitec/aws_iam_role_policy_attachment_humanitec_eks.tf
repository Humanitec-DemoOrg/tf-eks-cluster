resource "aws_iam_role_policy_attachment" "attach_humanitec_eks_policy_to_role" {
  role       = aws_iam_role.humanitec_agent_policy.name
  policy_arn = aws_iam_policy.humanitec-eks.arn
}

resource "aws_iam_role_policy_attachment" "attach_admin_eks_policy_to_role" {
  role       = aws_iam_role.humanitec_agent_policy.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}