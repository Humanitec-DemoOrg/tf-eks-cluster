variable "ingress_nginx_replica_count" {
  description = "Number of replicas for the ingress-nginx controller"
  type        = number
  default     = 2
}

variable "ingress_nginx_min_unavailable" {
  description = "Number of allowed unavaiable replicas for the ingress-nginx controller"
  type        = number
  default     = 1
}

variable "region" {
  type        = string
  description = "The region."
}

variable "humanitec_org" {
  type        = string
  description = "The name of the Humanitec Org"
}

variable "k8s_cluster_name" {
  type        = string
  description = "The name of the k8s cluster"
}

variable "k8s_cluster_arn" {
  type        = string
  description = "The arn of the k8s cluster"
}

variable "k8s_cluster_endpoint" {
  type        = string
  description = "The endpoint of the k8s cluster"
}

variable "domain_cert_arn" {
  type        = string
  description = "The endpoint of the k8s cluster"
}


variable "secret_store_name" {
  type        = string
  description = "The name of the Secret Store"
}

variable "k8s_cluster_ca_certificate" {
  type        = string
  description = "Certifcate for EKS"
}

variable "environment" {
  type        = string
  description = "The name of the platform env"
}

variable "environments" {
  type    = list(string)
  default = ["development", "preprod", "production"]
}

variable "tags" {
  type = map(string)
}

variable "dev_domain" {
  description = "Domain name for the environment"
  type        = string
}

variable "staging_domain" {
  description = "Domain name for the environment"
  type        = string
}

variable "prod_domain" {
  description = "Domain name for the environment"
  type        = string
}

variable "loadbalancer_class" {
  type    = string
  default = "alb"
}

variable "alb_controller_role_arn" {
  type    = string
  default = ""
}

variable "alb_controller_ingress_address" {
  type    = string
  default = ""
}