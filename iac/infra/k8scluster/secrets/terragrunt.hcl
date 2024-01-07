include "root" {
  path = find_in_parent_folders()
}

locals {
  kvm = yamldecode(file(find_in_parent_folders("kvm.yaml")))
}

terraform {
  source = "${get_terragrunt_dir()}/../../../components/k8s-secret"
}

inputs = {
  ssh_keys_path = local.kvm.ssh_keys_path
}