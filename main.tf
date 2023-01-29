locals {
  app_name         = "consul"
  consul_subdomain = "${local.app_name}.${var.stack}"
  consul_host      = "${local.consul_subdomain}.${var.domain}"
}

module "consul" {
  source       = "app.terraform.io/logistic/consul/helm"
  app_name     = local.app_name
  namespace    = var.namespace
  datacenter   = var.stack
  ingress_host = local.consul_host
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
  }
  ingress_enabled = var.create_ingress
}

module "records" {
  count = var.create_ingress ? 1 : 0
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = data.aws_route53_zone.zone[0].name
  records = [
    {
      name    = local.consul_subdomain
      type    = "CNAME"
      records = [data.aws_lb.ingress_lb[0].dns_name]
      ttl     = 30
    }
  ]
}
