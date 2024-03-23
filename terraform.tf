terraform {
  required_version = "1.7.5"
  required_providers {
    aws = {
      version = "5.42.0"
      source  = "hashicorp/aws"
    }
    kubernetes = {
      version = "2.27.0"
      source  = "hashicorp/kubernetes"
    }
    helm = {
      version = "2.12.1"
      source  = "hashicorp/helm"
    }
    vault = {
      version = "4.0.0"
      source  = "hashicorp/vault"
    }
    consul = {
      version = "2.20.0"
      source  = "hashicorp/consul"
    }
    random = {
      version = "3.6.0"
      source  = "hashicorp/random"
    }
  }
}
