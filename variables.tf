variable "stack" {
  type        = string
  description = "Stack name"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "namespace" {
  type        = string
  description = "Namespace for Consul release"
}

variable "domain" {
  type        = string
  description = "Root application domain name"
}

variable "certificate_issuer" {
  type        = string
  description = "Cert manager issuer name"
}

variable "server_replicas" {
  type        = number
  description = "Number of replicas to create"
  default     = 3
}

variable "bootstrap_expect" {
  type        = number
  description = "Minimum numbers of replicas to consider service ready"
  default     = 3
}

variable "vault_address" {
  type        = string
  description = "Vault http(s) address"
}

variable "vault_server_cert_secret" {
  type        = string
  description = "Secret containing Vault CA"
}

variable "vault_token_secret_id" {
  type        = string
  description = "Id vault root token secret in AWS Secret Manager"
  sensitive   = true
}

variable "vault_k8s_path" {
  type        = string
  description = "Vault path of K8s auth"
  default     = "kubernetes"
}

variable "pki_backend" {
  type        = string
  description = "PKI backend path"
}

variable "kv_backend" {
  type        = string
  description = "PKI backend path"
}
