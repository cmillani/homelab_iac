include "root" {
  path = find_in_parent_folders()
}

locals {
  kvm = yamldecode(file(find_in_parent_folders("kvm.yaml")))
}

dependency "pool" {
  config_path = "${get_terragrunt_dir()}/../kvm/homelab/pool"
}

dependency "baseimage" {
  config_path = "${get_terragrunt_dir()}/../kvm/homelab/base-image"
}

include "homelab" {
  path = "${get_terragrunt_dir()}/../kvm/_base/homelab-provider.hcl"
}

terraform {
  source = "${get_terragrunt_dir()}/../../components/libvirt-vm"
}

inputs = {
  ansible_path = "${get_terragrunt_dir()}/hass-install.yml"

  pool_name = dependency.pool.outputs.pool_name
  base_volume_name = dependency.baseimage.outputs.volume_name

  image_name = "homeassistant"

  ssh_keys_path = local.kvm.ssh_keys_path

  disk_size = 21474836480 # 20 GB
  ipv4_address = "192.168.1.116"
  vcpu = 1
  memory = "2048"
  cinit_user_data_path = "${get_terragrunt_dir()}/cloud_init.cfg"
  cinit_network_config_path = "${get_terragrunt_dir()}/network_config.cfg"
  bridge_name = local.kvm.bridge_name
}
