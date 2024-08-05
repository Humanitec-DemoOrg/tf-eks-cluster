# Working with AWS load balancer ingress controller 

```
Note: 

This is the specific instructions for installing the AWS Load Balancer Controller for use with AWS EKS, as well as instructions on how to configure Humanitec to make use of it. Whilst not necessary if following this guide, the official instructions for the AWS Load Balancer Controller can be found here: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/installation/#add-controller-to-cluster
```

```
Note:

This example assumes you are using IRSA and Pod Identities, rather than static credentials. Due to best practice, this is the recommended implementation.
```

## Working Example Code

If you’d like to skip the below and just look directly at a working example, you can head to GitHub here: https://github.com/Humanitec-DemoOrg/tf-eks-cluster

Alternatively, if you already have the Load Balancer Controller installed and you just want to understand how to get it to work with Humanitec, then skip to Using the AWS Load Balancer Controller with Humanitec step.

## Installing the Load Balancer Controller using Terraform

If you didn’t take the early chance to leave, then you can install the AWS Load Balancer Controller easily using the Helm provider for Terraform:

```

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      # Be sure to use the latest version
      version = "~> 2.12"
    }
	
    kubernetes = {
      source  = "hashicorp/kubernetes"
      # Be sure to use the latest version
      version = ">= 2.0.3"
    }

  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = false
  repository       = "https://aws.github.io/eks-charts"

  chart   = "aws-load-balancer-controller"
  # Be sure to use the latest version
  version = "1.4.5" 
  wait    = true
  timeout = 600

  set {
    name  = "clusterName"
    value = var.k8s_cluster_name
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

 }
```

You will also need to create the service account, which you can also create via Terraform if using the Kubernetes provider:

```
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
    }
  }
}
```


The ALB Controller Role ARN is the role that has the necessary permissions. The official policy is here: https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/install/iam_policy.json but here is one prepared in Terraform for you:

```
resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeTags",
                "ec2:GetCoipPoolUsage",
                "ec2:DescribeCoipPools",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTrustStores"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:DescribeUserPoolClient",
                "acm:ListCertificates",
                "acm:DescribeCertificate",
                "iam:ListServerCertificates",
                "iam:GetServerCertificate",
                "waf-regional:GetWebACL",
                "waf-regional:GetWebACLForResource",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL",
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL",
                "shield:GetSubscriptionState",
                "shield:DescribeProtection",
                "shield:CreateProtection",
                "shield:DeleteProtection"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSecurityGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": "CreateSecurityGroup"
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:DeleteRule"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:DeleteTargetGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition": {
                "StringEquals": {
                    "elasticloadbalancing:CreateAction": [
                        "CreateTargetGroup",
                        "CreateLoadBalancer"
                    ]
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeregisterTargets"
            ],
            "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:SetWebAcl",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:ModifyRule"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
```

The above will need attaching to a role, using the OIDC provider ARN of the EKS cluster:

```
locals {
  oidc_id = basename("${module.eks_bottlerocket.oidc_provider_arn}")
}

resource "aws_iam_role" "eks_load_balancer_controller_role" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${module.eks_bottlerocket.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}:aud": "sts.amazonaws.com",
          "oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lb_policy_to_role" {
  role       = aws_iam_role.eks_load_balancer_controller_role.name
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}


```


At this point you should be able to run your Terraform code to deploy the IAM Roles & Kubernetes Service account as well as deploy the AWS Load Balancer Controller via Helm.

You now have everything you need to start integrating with Humanitec.

## Using the AWS Load Balancer Controller with Humanitec

At this point you should be able to run your Terraform code to deploy the IAM Roles & Kubernetes Service account as well as deploy the AWS Load Balancer Controller via Helm.

You now have everything you need to start integrating with Humanitec.

Using the AWS Load Balancer Controller with Humanitec

To make use of the AWS Load Balancer, all you need to do is ensure that your ingress resources that are deployed use the correct annotations. You can configure this by creating a custom resource definition for you ingress like so:

```
resource "humanitec_resource_definition" "ingress_alb" {
  id          = "ingress-alb"
  name        = "ingress-alb"
  type        = "ingress"
  driver_type = "humanitec/ingress"

  driver_inputs = {
    values_string = jsonencode({
      "annotations" : {
        "alb.ingress.kubernetes.io/certificate-arn" : "${var.domain_cert_arn}",
        "alb.ingress.kubernetes.io/group.name" : "humanitec-ingress-group",
        "alb.ingress.kubernetes.io/listen-ports" : "[{\"HTTP\":80},{\"HTTPS\":443}]",
        "alb.ingress.kubernetes.io/scheme" : "internet-facing",
        "alb.ingress.kubernetes.io/ssl-redirect" : "443",
        "alb.ingress.kubernetes.io/target-type" : "ip"
      },
      "class" : "alb",
      "no_tls" : true
    })
  }
}

resource "humanitec_resource_definition_criteria" "ingress-alb-development" {
  resource_definition_id = humanitec_resource_definition.ingress_alb.id
  env_type               = "development"
}
```

You will likely have a corresponding resource definition to use Route53:

```
data "aws_route53_zone" "dev_zone" {
  name = var.dev_domain
}

resource "humanitec_resource_definition" "dev_dns_alb" {
  id    = "example-dns-dev-alb"
  name  = "Bobby Example DNS Dev"
  type  = "dns"

  driver_type    = "humanitec/dns-aws-route53"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      domain         = var.dev_domain
      hosted_zone_id = data.aws_route53_zone.dev_zone.id
      template       = "$${context.app.id}"
    })
  }

  provision = {
    ingress = {
      is_dependent = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "dev_dns_alb" {
  resource_definition_id = humanitec_resource_definition.dev_dns_alb.id
  env_id                 = "development"
  force_delete           = true
}   
```

You will see the annotations on the ingress resource definition are the correct ones to use with the AWS Load Balancer Controller. It is important to use just one `alb.ingress.kubernetes.io/group.name` as otherwise multiple Load Balancers will be configure which is not supported by humanitec.


Once you have your Load Balancer, it is important that you grab the endpoint, and pass it as the `loadbalancer` driver_input value:

```
resource "humanitec_resource_definition" "eks-dynamic-credentials" {
  id          = "eks-dynamic-credentials-${var.environment}"
  name        = "eks-dynamic-credentials-${var.environment}"
  type        = "k8s-cluster"
  driver_type = "humanitec/k8s-cluster-eks"
  # The driver_account is referring to a Cloud Account resource
  driver_account = humanitec_resource_account.cloud_account.id

  driver_inputs = {
    values_string = jsonencode({
      "name"                     = var.k8s_cluster_name
      "region"                   = var.region
      "loadbalancer"             = local.ingress_address
      "loadbalancer_hosted_zone" = data.aws_elb_hosted_zone_id.main.id
    })
  }
}
```

If you have any issues following this guide, all the above code is referenced in this working example: https://github.com/Humanitec-DemoOrg/tf-eks-cluster

The example also includes support for the `ingress-nginx` controller, so you will see support for a type of either `alb` or `nginx`. If you would like to see the guide for setting up the `ingress-nginx` controller, you can find that here (TBC)

You can always contact Humanitec Support should you need any further assistance.