locals {
  app_name                      = "consul"
  ingress_host                  = "${local.app_name}.${var.domain}"
  consul_address                = "https://${local.ingress_host}"
  connect_pki_path              = "connect-root"
  connect_intermediate_pki_path = "connect-intermediate-${var.stack}"
  gossip_key                    = "gossip"
  consul_gossip_secret_path     = "consul/gossip"
  consul_gossip_read_path       = "${var.kv_backend}/data/${local.consul_gossip_secret_path}"

}

resource "helm_release" "consul-server" {
  depends_on = [
    vault_pki_secret_backend_root_cert.consul_root_cert,
    vault_generic_secret.consul_gossip_key,
    kubernetes_manifest.kubernetes_crds,
    kubernetes_manifest.consul_crds
  ]
  name       = local.app_name
  namespace  = var.namespace
  atomic     = true
  chart      = "consul"
  repository = "https://helm.releases.hashicorp.com"

  values = [
    yamlencode({
      global = {
        name       = local.app_name
        datacenter = var.stack
        tls = {
          enabled           = true
          enableAutoEncrypt = true
          caCert = {
            secretName = "${var.pki_backend}/cert/ca"
          }
        }
        gossipEncryption = {
          secretName = local.consul_gossip_read_path
          secretKey  = local.gossip_key
        }
        secretsBackend = {
          vault = {
            enabled          = true
            consulServerRole = vault_kubernetes_auth_backend_role.consul_server.role_name
            consulClientRole : vault_kubernetes_auth_backend_role.consul_client.role_name
            consulCARole : vault_kubernetes_auth_backend_role.ca.role_name
            connectCA = {
              address             = "https://vault.${var.namespace}.svc"
              rootPKIPath         = local.connect_pki_path
              intermediatePKIPath = local.connect_intermediate_pki_path
            }
            ca = {
              secretName = var.vault_server_cert_secret
              secretKey  = "ca.crt"
            }
          }
        }
        acls = {
          manageSystemACLs = true
        }
        metrics = {
          enabled = false
        }
      }
      server = {
        replicas = var.server_replicas
        bootstrapExpect : var.bootstrap_expect
        serverCert = {
          secretName : "${var.pki_backend}/issue/consul-server"
        }
      }
      syncCatalog = {
        enabled = true
        default = true
        consulNamespaces = {
          mirroringK8S      = true
          k8sDenyNamespaces = ["kube-system", "kube-public", "default"]
        }
      }
      ui = {
        service = {
          type = "ClusterIP"
        }
        metrics = {
          enabled = false
        }
        ingress = {
          enabled = true
          hosts = [
            {
              host = local.ingress_host
              paths = [
                "/"
              ]
            }
          ]
          tls = [
            {
              secretName = "${local.app_name}-ingress-cert"
              hosts = [
                local.ingress_host
              ]
            }
          ]
          annotations = jsonencode({
            "kubernetes.io/ingress.class"                                       = "nginx"
            "kubernetes.io/ingress.allow-http"                                  = "false"
            "nginx.ingress.kubernetes.io/backend-protocol"                      = "HTTPS"
            "nginx.ingress.kubernetes.io/force-ssl-redirect"                    = "true"
            "nginx.ingress.kubernetes.io/auth-tls-verify-client"                = "off"
            "nginx.ingress.kubernetes.io/auth-tls-pass-certificate-to-upstream" = "false"
            "cert-manager.io/cluster-issuer"                                    = var.certificate_issuer
            "external-dns.alpha.kubernetes.io/hostname"                         = local.ingress_host
          })
        }
      }
      connectInject = {
        enabled = true
        transparentProxy = {
          transparentProxy = true
        }
        metrics = {
          defaultEnabled = false
        }
      }
      apiGateway = {
        enabled = true
        image   = "hashicorp/consul-api-gateway:${var.api_gateway_version}"
        managedGatewayClass = {
          useHostPorts = true
        }
      }
    })
  ]
}
