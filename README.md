## Introduction
Terraform module to create Consul cluster on AWS EKS

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_consul"></a> [consul](#module\_consul) | app.terraform.io/logistic/consul/helm | 0.0.2 |
| <a name="module_records"></a> [records](#module\_records) | terraform-aws-modules/route53/aws//modules/records | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_lb.ingress_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Consul app name | `string` | `"consul"` | no |
| <a name="input_bootstrap_expect"></a> [bootstrap\_expect](#input\_bootstrap\_expect) | Minimum numbers of replicas to consider service ready | `number` | `1` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_create_ingress"></a> [create\_ingress](#input\_create\_ingress) | Flag to create ingress | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Root application domain name | `string` | n/a | yes |
| <a name="input_lb_arn"></a> [lb\_arn](#input\_lb\_arn) | n/a | `string` | `"ARN of NLB for ingress"` | no |
| <a name="input_server_replicas"></a> [server\_replicas](#input\_server\_replicas) | Number of replicas to create | `number` | `1` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | Stack name | `string` | n/a | yes |
| <a name="input_tooling_namespace"></a> [tooling\_namespace](#input\_tooling\_namespace) | Namespace for Consul release | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
