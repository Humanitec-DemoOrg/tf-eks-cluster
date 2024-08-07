module "oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "1.7.1"

  github_repositories = [
    "Humanitec-DemoOrg/demo-affiliate-tracking"
  ]

  iam_role_inline_policies = {
    "ecr_repos" : data.aws_iam_policy_document.ecr_repos.json,
    "s3_access" : data.aws_iam_policy_document.s3.json
  }
}

data "aws_iam_policy_document" "ecr_repos" {
  statement {
    actions   = ["ecr:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}