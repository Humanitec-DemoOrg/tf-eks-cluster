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

variable "domain_aliases" {
  description = "List of domain aliases"
  type        = list(string)
  default     = []
}