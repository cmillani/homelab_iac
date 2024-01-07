include "root" {
  path = find_in_parent_folders()
}

locals {
  kvm = yamldecode(file(find_in_parent_folders("kvm.yaml")))
  is_worker = true
  k8s_version = "v1.24"
}

dependency "pool" {
  config_path = "${get_terragrunt_dir()}/../../kvm/homelab/pool"
}

dependency "baseimage" {
  config_path = "${get_terragrunt_dir()}/../../kvm/homelab/base-image"
}

dependency "secrets" {
  config_path = "${get_terragrunt_dir()}/../secrets"
}

include "ryzenlab" {
  path = "${get_terragrunt_dir()}/../../kvm/_base/ryzenlab-provider.hcl"
}

terraform {
  source = "${get_terragrunt_dir()}/../../../components/libvirt-vm"
}

inputs = {
  ansible_path = "${get_terragrunt_dir()}/../_ansible/worker-node.yaml"
  ansible_extra_vars = "k8s_secret=${dependency.secrets.outputs.k8s_token} k8s_key=${dependency.secrets.outputs.k8s_key} is_worker=${local.is_worker} k8s_version=${local.k8s_version}"

  pool_name = dependency.pool.outputs.pool_name
  base_volume_name = dependency.baseimage.outputs.volume_name

  image_name = "worker04"

  ssh_keys_path = local.kvm.ssh_keys_path

  disk_size = local.kvm.disk_sz
  ipv4_address = "192.168.1.123"
  vcpu = 2
  memory = "2048"
  cinit_user_data_path = "${get_terragrunt_dir()}/../cloud_init.cfg"
  cinit_network_config_path = "${get_terragrunt_dir()}/../network_config.cfg"
  bridge_name = local.kvm.bridge_name
}
  