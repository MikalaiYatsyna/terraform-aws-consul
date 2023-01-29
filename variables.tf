variable "stack" {
  type        = string
  description = "Stack name"
}

variable "namespace" {
  type        = string
  description = "Namespace for Consul release"
}

variable "domain" {
  type        = string
  description = "Root application domain name"
}

variable "create_ingress" {
  type = bool
  description = "Flag to create ingress"
}