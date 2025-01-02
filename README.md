## Introduction
Terraform module to create Consul cluster on AWS EKS

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.10.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.82.2 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | 2.21.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.17.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.35.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |
| <a name="provider_consul"></a> [consul](#provider\_consul) | 2.21.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [consul_acl_policy.policy](https://registry.terraform.io/providers/hashicorp/consul/2.21.0/docs/resources/acl_policy) | resource |
| [helm_release.consul-server](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [random_password.bootstrap_token](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) | resource |
| [random_password.gossip_key](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) | resource |
| [vault_consul_secret_backend.test](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/consul_secret_backend) | resource |
| [vault_consul_secret_backend_role.role](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/consul_secret_backend_role) | resource |
| [vault_generic_secret.consul_boostrap_token](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/generic_secret) | resource |
| [vault_generic_secret.consul_gossip_key](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/generic_secret) | resource |
| [vault_kubernetes_auth_backend_role.acl](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kubernetes_auth_backend_role.ca](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kubernetes_auth_backend_role.consul_client](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kubernetes_auth_backend_role.consul_server](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_pki_secret_backend_role.consul_server](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/pki_secret_backend_role) | resource |
| [vault_pki_secret_backend_root_cert.consul_root_cert](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/pki_secret_backend_root_cert) | resource |
| [vault_policy.acl](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/policy) | resource |
| [vault_policy.ca](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/policy) | resource |
| [vault_policy.consul_gossip](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/policy) | resource |
| [vault_policy.consul_server](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/resources/policy) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/5.82.2/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/5.82.2/docs/data-sources/eks_cluster_auth) | data source |
| [aws_secretsmanager_secret_version.root_token](https://registry.terraform.io/providers/hashicorp/aws/5.82.2/docs/data-sources/secretsmanager_secret_version) | data source |
| [kubernetes_secret.consul_bootstrap_token](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/data-sources/secret) | data source |
| [vault_policy_document.acl](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/data-sources/policy_document) | data source |
| [vault_policy_document.ca](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/data-sources/policy_document) | data source |
| [vault_policy_document.consul_gossip](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/data-sources/policy_document) | data source |
| [vault_policy_document.consul_server](https://registry.terraform.io/providers/hashicorp/vault/4.1.0/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_expect"></a> [bootstrap\_expect](#input\_bootstrap\_expect) | Minimum numbers of replicas to consider service ready | `number` | `3` | no |
| <a name="input_certificate_issuer"></a> [certificate\_issuer](#input\_certificate\_issuer) | Cert manager issuer name | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Root application domain name | `string` | n/a | yes |
| <a name="input_kv_backend"></a> [kv\_backend](#input\_kv\_backend) | PKI backend path | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Consul release | `string` | n/a | yes |
| <a name="input_pki_backend"></a> [pki\_backend](#input\_pki\_backend) | PKI backend path | `string` | n/a | yes |
| <a name="input_server_replicas"></a> [server\_replicas](#input\_server\_replicas) | Number of replicas to create | `number` | `3` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | Stack name | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault http(s) address | `string` | n/a | yes |
| <a name="input_vault_k8s_path"></a> [vault\_k8s\_path](#input\_vault\_k8s\_path) | Vault path of K8s auth | `string` | `"kubernetes"` | no |
| <a name="input_vault_server_cert_secret"></a> [vault\_server\_cert\_secret](#input\_vault\_server\_cert\_secret) | Secret containing Vault CA | `string` | n/a | yes |
| <a name="input_vault_token_secret_id"></a> [vault\_token\_secret\_id](#input\_vault\_token\_secret\_id) | Id vault root token secret in AWS Secret Manager | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
