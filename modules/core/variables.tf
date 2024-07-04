variable "domain" {
  description = "Domain name for the environment"
  type        = string
}

variable "domain_aliases" {
  description = "List of domain aliases"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The environment (dev or prod)"
  type        = string
}
