data "aws_lb" "ingress_lb" {
  count = var.create_ingress ? 1 : 0
  depends_on = [module.consul]
  name       = var.stack
}

data "aws_route53_zone" "zone" {
  count = var.create_ingress ? 1 : 0
  name = var.domain
}