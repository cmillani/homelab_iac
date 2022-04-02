## Terraform does not support for_each provider https://github.com/hashicorp/terraform/issues/24476
## Terragrunt may help with this
## Also, for easyness of use this module also creates a pool - this should be refactored for clarity
module "base_image_homelab" {
  source = "./tf-modules/base-image"
  providers = {
    libvirt = libvirt.homelab
  }
}
module "base_image_ryzenlab" {
  source = "./tf-modules/base-image"
  providers = {
    libvirt = libvirt.ryzenlab
  }
}

## Homeassistant VM
module "vm_homeassistant" {
  source = "./homeassistant"
  vm_config = {
    ipv4 = "192.168.1.116"
    base_image_pool = module.base_image_homelab.pool_name
    base_image_name = module.base_image_homelab.volume_name
    bridge_name = local.bridge_name
  }
  providers = {
    libvirt = libvirt.homelab
  }
}

## Kubernetes Cluster
module "k8s_cluster" {
  source = "./k8scluster"
  base = {
    base_image_pool = module.base_image_homelab.pool_name
    base_image_name = module.base_image_homelab.volume_name
    bridge_name = local.bridge_name
  }
  ipv4s = {
    kubeadm = "192.168.1.119"
    node01 = "192.168.1.120"
    node02 = "192.168.1.121"
  }
  providers = {
    libvirt.kubeadm = libvirt.ryzenlab
    libvirt.node01 = libvirt.ryzenlab
    libvirt.node02 = libvirt.homelab
  }
}
