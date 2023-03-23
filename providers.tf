provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}

provider "vault" {
  address = var.vault_address
  token   = jsondecode(data.aws_secretsmanager_secret_version.root_token.secret_string)["token"]
}

provider "consul" {
  address = "https://${local.ingress_host}"
  token = data.kubernetes_secret.consul_bootstrap_token.data["token"]
}
