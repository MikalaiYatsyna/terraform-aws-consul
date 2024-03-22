data "aws_secretsmanager_secret_version" "root_token" {
  secret_id = var.vault_token_secret_id
}

data "kubernetes_secret" "consul_bootstrap_token" {
  depends_on = [helm_release.consul-server]
  metadata {
    name      = local.bootstrap_token_secret_name
    namespace = var.namespace
  }
}
