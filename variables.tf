variable "app_name" {
  type        = string
  description = "Consul app name"
  default     = "consul"
}

variable "stack" {
  type        = string
  description = "Stack name"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "lb_arn" {
  type    = string
  default = "ARN of NLB for ingress"
}

variable "tooling_namespace" {
  type        = string
  description = "Namespace for Consul release"
}

variable "domain" {
  type        = string
  description = "Root application domain name"
}

variable "create_ingress" {
  type        = bool
  description = "Flag to create ingress"
  default     = true
}

variable "server_replicas" {
  type        = number
  default     = 1
  description = "Number of replicas to create"
}

variable "bootstrap_expect" {
  type        = number
  default     = 1
  description = "Minimum numbers of replicas to consider service ready"
}
