locals {
  kvm = yamldecode(file(find_in_parent_folders("kvm.yaml")))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../../components/base-image"
}

inputs = {
  image_name = "debian-12"
  image_url = "https://cloud.debian.org/images/cloud/bookworm/20240102-1614/debian-12-generic-amd64-20240102-1614.qcow2"
  image_file_type = "qcow2"
  pool_name = "${local.kvm.pool_name}"
}