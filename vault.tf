resource "random_password" "gossip_key" {
  length  = 32
  special = false
}

resource "vault_generic_secret" "consul_gossip_key" {
  path = "${var.kv_backend}/${local.consul_gossip_secret_path}"
  data_json = jsonencode({
    (local.gossip_key) = random_password.gossip_key.result
  })
}

resource "vault_pki_secret_backend_root_cert" "consul_root_cert" {
  backend     = var.pki_backend
  common_name = "${var.stack}.consul"
  ttl         = "87600h"
  type        = "internal"
}

resource "vault_pki_secret_backend_role" "consul_server" {
  backend = var.pki_backend
  name    = vault_kubernetes_auth_backend_role.consul_server.role_name
  allowed_domains = [
    "consul-server",
    "consul-server.${var.namespace}",
    "consul-server.${var.namespace}.svc",
    "consul-server.${var.namespace}.svc.cluster",
    "consul-server.${var.namespace}.svc.cluster.local",
    "server.${var.stack}.consul"
  ]
  allow_subdomains   = true
  allow_bare_domains = true
  allow_localhost    = true
  generate_lease     = true
  max_ttl            = "720h"
}

resource "vault_mount" "connect_root" {
  path        = "connect-root"
  type        = "pki"
  description = "PKI secrets engine for Consul Connect"
}

data "vault_policy_document" "consul_gossip" {
  rule {
    path         = local.consul_gossip_read_path
    capabilities = ["read"]
    description  = "Allow to read Consul gossip encryption key"
  }
}

resource "vault_policy" "consul_gossip" {
  name   = "gossip-policy"
  policy = data.vault_policy_document.consul_gossip.hcl
}

data "vault_policy_document" "consul_server" {
  rule {
    path         = "${var.kv_backend}/data/consul-server"
    capabilities = ["read"]
  }
  rule {
    path         = "${var.pki_backend}/issue/consul-server"
    capabilities = ["read", "update"]
  }
  rule {
    path         = "${var.pki_backend}/cert/ca"
    capabilities = ["read"]
  }
}

resource "vault_policy" "consul_server" {
  name   = "consul-server"
  policy = data.vault_policy_document.consul_server.hcl
}

data "vault_policy_document" "ca" {
  rule {
    path         = "${var.pki_backend}/cert/ca"
    capabilities = ["read"]
  }
}

resource "vault_policy" "ca" {
  name   = "ca-policy"
  policy = data.vault_policy_document.ca.hcl
}


# Service mesh policy
data "vault_policy_document" "service_mesh" {
  rule {
    path         = "/sys/mounts/${local.connect_pki_path}"
    capabilities = ["create", "read", "update", "delete", "list"]
  }
  rule {
    path         = "/sys/mounts/${local.connect_intermediate_pki_path}"
    capabilities = ["create", "read", "update", "delete", "list"]
  }
  rule {
    path         = "/sys/mounts/${local.connect_intermediate_pki_path}/tune"
    capabilities = ["update"]
  }
  rule {
    path         = "/${local.connect_pki_path}/*"
    capabilities = ["create", "read", "update", "delete", "list"]
  }
  rule {
    path = "/${local.connect_intermediate_pki_path}/*"

    capabilities = ["create", "read", "update", "delete", "list"]
  }
  rule {
    path         = "auth/token/renew-self"
    capabilities = ["update"]
  }
  rule {
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
  }
}

resource "vault_policy" "connect" {
  name   = "service-mesh-policy"
  policy = data.vault_policy_document.service_mesh.hcl
}

resource "vault_kubernetes_auth_backend_role" "consul_server" {
  backend                          = var.vault_k8s_path
  role_name                        = "consul-server"
  bound_service_account_namespaces = [var.namespace]
  bound_service_account_names      = ["consul-server"]
  token_ttl                        = 60 * 60 * 24 # 1 day
  token_max_ttl                    = 60 * 60 * 24 # 1 day
  token_policies = [
    vault_policy.consul_gossip.name, vault_policy.consul_server.name,
    vault_policy.connect.name, vault_policy.ca.name
  ]
}

resource "vault_kubernetes_auth_backend_role" "consul_client" {
  backend                          = var.vault_k8s_path
  role_name                        = "consul-client"
  bound_service_account_namespaces = [var.namespace]
  bound_service_account_names      = ["consul-client"]
  token_ttl                        = 60 * 60 * 24 # 1 day
  token_max_ttl                    = 60 * 60 * 24 # 1 day
  token_policies                   = [vault_policy.consul_gossip.name, vault_policy.ca.name]
}

resource "vault_kubernetes_auth_backend_role" "ca" {
  backend                          = var.vault_k8s_path
  role_name                        = "ca-role"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = [var.namespace]
  token_ttl                        = 60 * 60 # 1 hour
  token_max_ttl                    = 60 * 60 # 1 hour
  token_policies                   = [vault_policy.ca.name]
}
