terraform {
  required_version = "1.10.3"
  required_providers {
    aws = {
      version = "5.42.0"
      source  = "hashicorp/aws"
    }
    kubernetes = {
      version = "2.35.1"
      source  = "hashicorp/kubernetes"
    }
    helm = {
      version = "2.12.1"
      source  = "hashicorp/helm"
    }
    vault = {
      version = "4.1.0"
      source  = "hashicorp/vault"
    }
    consul = {
      version = "2.21.0"
      source  = "hashicorp/consul"
    }
    random = {
      version = "3.6.3"
      source  = "hashicorp/random"
    }
  }
}
