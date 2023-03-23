resource "vault_consul_secret_backend" "test" {
  path        = "consul"
  description = "Consul backend"
  address     = "consul-server:8500"
  token = data.kubernetes_secret.consul_bootstrap_token.data["token"]
}

resource "vault_consul_secret_backend_role" "role" {
  name      = "consul-role"
  policies  = [consul_acl_policy.policy.name]
  backend   = vault_consul_secret_backend.test.path
}

resource "consul_acl_policy" "policy" {
  name  = "server-policy"
  rules = <<EOF
    node_prefix "server-" {
      policy = "write"
    }
    node_prefix "" {
      policy = "read"
    }
    service_prefix "" {
      policy = "read"
    }
  EOF
}
