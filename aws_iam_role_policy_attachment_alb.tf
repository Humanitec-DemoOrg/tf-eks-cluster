resource "aws_iam_role_policy_attachment" "attach_lb_policy_to_role" {
  role       = aws_iam_role.eks_load_balancer_controller_role.name
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}
