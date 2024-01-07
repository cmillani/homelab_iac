locals {
  kvm = yamldecode(file(find_in_parent_folders("kvm.yaml")))
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "libvirt" {
  uri = "${local.kvm.libvirt_uris.homelab}"
}
EOF
}