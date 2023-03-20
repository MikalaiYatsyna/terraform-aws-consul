resource "vault_mount" "consul" {
  path = "consul"
  type = "consul"
}
