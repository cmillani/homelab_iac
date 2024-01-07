locals {
  kvm = yamldecode(file(find_in_parent_folders("kvm.yaml")))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../../components/image-pool"
}

inputs = {
  pool_name = "${local.kvm.pool_name}"
  pool_path = "/home/carlos/iac"
}