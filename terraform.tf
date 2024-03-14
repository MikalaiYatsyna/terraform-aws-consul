terraform {
  required_version = "1.7.5"
  required_providers {
    aws = {
      version = "4.59.0"
      source  = "hashicorp/aws"
    }
    kubernetes = {
      version = "2.18.1"
      source = "hashicorp/kubernetes"
    }
    helm = {
      version = "2.9.0"
      source = "hashicorp/helm"
    }
    vault = {
      version = "3.14.0"
      source = "hashicorp/vault"
    }
    consul = {
      version = "2.17.0"
      source = "hashicorp/consul"
    }
    random = {
      version = "3.4.3"
      source = "hashicorp/random"
    }
  }
}
