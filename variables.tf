variable "cluster_name" {
  type        = string
  description = "The name of the EKS Cluster."
}

variable "env" {
  type        = string
  description = "The name of the env."
}

variable "region" {
  type        = string
  description = "The region."
}

variable "vpc_id" {
  type        = string
  description = "The vpc."
}

variable "domain" {
  description = "Domain name for the environment"
  type        = string
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

variable "domain_aliases" {
  description = "List of domain aliases"
  type        = list(string)
  default     = []
}

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