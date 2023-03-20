data "http" "consul_apigw_kustomization_file" {
  url = "https://raw.githubusercontent.com/hashicorp/consul-api-gateway/main/config/crd/kustomization.yaml"
}

locals {
  crds = yamldecode(data.http.consul_apigw_kustomization_file.response_body)["resources"]
}

data "http" "crds" {
  for_each = local.crds
  url = each.value
}

resource "kubernetes_manifest" "api_gw_crds" {
  for_each = data.http.crds
  manifest = data.http.crds.response_body
}
