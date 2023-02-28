locals {
  consul_host      = "${var.app_name}.${var.domain}"
}

module "consul" {
  source           = "app.terraform.io/logistic/consul/helm"
  version          = "0.0.2"
  app_name         = var.app_name
  namespace        = var.tooling_namespace
  datacenter       = var.stack
  server_replicas  = var.server_replicas
  bootstrap_expect = var.bootstrap_expect
  ingress_host     = local.consul_host
  ingress_enabled  = var.create_ingress
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
  }
}

module "records" {
  count  = var.create_ingress ? 1 : 0
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = data.aws_route53_zone.zone[0].name
  records = [
    {
      name    = var.app_name
      type    = "CNAME"
      records = [data.aws_lb.ingress_lb[0].dns_name]
      ttl     = 30
    }
  ]
}
