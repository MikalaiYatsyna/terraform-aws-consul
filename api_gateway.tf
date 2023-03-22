locals {
  kubernetes_crds_path  = "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${var.kubernetes_api_gw_version}/config/crd/experimental"
  kubernetes_crds_files = [
    "gateway.networking.k8s.io_gatewayclasses.yaml",
    "gateway.networking.k8s.io_gateways.yaml",
    "gateway.networking.k8s.io_httproutes.yaml",
    "gateway.networking.k8s.io_referencegrants.yaml",
    "gateway.networking.k8s.io_referencepolicies.yaml",
    "gateway.networking.k8s.io_tcproutes.yaml",
    "gateway.networking.k8s.io_tlsroutes.yaml",
    "gateway.networking.k8s.io_udproutes.yaml"
  ]
  consul_crds_path  = "https://raw.githubusercontent.com/hashicorp/consul-api-gateway/${var.api_gateway_version}/config/crd/bases/"
  consul_crds_files = [
    "api-gateway.consul.hashicorp.com_meshservices.yaml",
    "api-gateway.consul.hashicorp.com_gatewayclassconfigs.yaml"
  ]
}

data "http" "kubernetes_crd_content" {
  for_each = toset(local.kubernetes_crds_files)
  url      = "${local.kubernetes_crds_path}/${each.key}"
}

data "http" "consul_crd_content" {
  for_each = toset(local.consul_crds_files)
  url      = "${local.consul_crds_path}/${each.key}"
}

resource "kubernetes_manifest" "kubernetes_crds" {
  for_each = data.http.kubernetes_crd_content
  #  https://github.com/hashicorp/terraform-provider-kubernetes/issues/1428
  manifest = yamldecode(replace(each.value.response_body, "/(?s:\nstatus:.*)$/", ""))
}

resource "kubernetes_manifest" "consul_crds" {
  for_each = data.http.consul_crd_content
  #  https://github.com/hashicorp/terraform-provider-kubernetes/issues/1428
  manifest = yamldecode(replace(each.value.response_body, "/(?s:\nstatus:.*)$/", ""))
}
