terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      configuration_aliases = [ libvirt.kubeadm, libvirt.node01, libvirt.node02 ]
    }
  }
}

locals {
    disk_size = 32212254720 # 30 GB
    kubeadm = {
        name = "kubeadm"
        vcpu = 2
        memory = 2048
    }
    node01 = {
        name = "node01"
        vcpu = 4
        memory = 5120
    }
    node02 = {
        name = "node02"
        vcpu = 3
        memory = 5120
    }
}

# Kubeadm secret must be format [a-z0-9]{6}.[a-z0-9]{16}
resource "random_password" "lower" {
  length = 6
  special = false
  upper = false
}
resource "random_password" "upper" {
  length = 16
  special = false
  upper = false
}

# Modules
# TODO: reuse module definitio - currenlty limited due to parametrized provider
module "kubeadm" {
  source = "../tf-modules/libvirt-vm"

  base_image_pool_name = var.base.base_image_pool
  base_volume_name  = var.base.base_image_name

  image_name = local.kubeadm.name

  disk_size = local.disk_size
  ipv4_address = var.base.bridge_name
  vcpu = local.kubeadm.vcpu
  memory = local.kubeadm.memory
  cinit_user_data      = templatefile("${path.module}/cloud_init.cfg", { 
    SSH_PUB_KEY: file(var.ssh_keys_path.public),
    HOSTNAME: local.kubeadm.name
  })
  cinit_network_config = templatefile("${path.module}/network_config.cfg", {
    IPV4_ADDR: var.ipv4s.kubeadm
  })
  bridge_name = var.base.bridge_name

  providers = {
      libvirt = libvirt.kubeadm
  }
}

module "node01" {
  source = "../tf-modules/libvirt-vm"

  base_image_pool_name = var.base.base_image_pool
  base_volume_name  = var.base.base_image_name

  image_name = local.node01.name

  disk_size = local.disk_size
  ipv4_address = var.base.bridge_name
  vcpu = local.node01.vcpu
  memory = local.node01.memory
  cinit_user_data      = templatefile("${path.module}/cloud_init.cfg", { 
    SSH_PUB_KEY: file(var.ssh_keys_path.public),
    HOSTNAME: local.node01.name
  })
  cinit_network_config = templatefile("${path.module}/network_config.cfg", {
    IPV4_ADDR: var.ipv4s.node01
  })
  bridge_name = var.base.bridge_name

  providers = {
      libvirt = libvirt.node01
  }
}

module "node02" {
  source = "../tf-modules/libvirt-vm"

  base_image_pool_name = var.base.base_image_pool
  base_volume_name  = var.base.base_image_name

  image_name = local.node02.name

  disk_size = local.disk_size
  ipv4_address = var.base.bridge_name
  vcpu = local.node02.vcpu
  memory = local.node02.memory
  cinit_user_data      = templatefile("${path.module}/cloud_init.cfg", { 
    SSH_PUB_KEY: file(var.ssh_keys_path.public),
    HOSTNAME: local.node02.name
  })
  cinit_network_config = templatefile("${path.module}/network_config.cfg", {
    IPV4_ADDR: var.ipv4s.node02
  })
  bridge_name = var.base.bridge_name

  providers = {
      libvirt = libvirt.node02
  }
}

# Post install
# ADM init cluster
resource "null_resource" "post_install_adm" {
  triggers = {
    vm_id = module.kubeadm.id
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.ipv4s.kubeadm},' --private-key ${var.ssh_keys_path.private} -e 'pub_key=${var.ssh_keys_path.public}' --extra-vars 'k8s_secret=${random_password.lower.result}.${random_password.upper.result}' ${path.module}/control-node.yaml"
  }
}

# Join workers
resource "null_resource" "post_install_workers" {
  triggers = {
    adm_id = null_resource.post_install_adm.id
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.ipv4s.node01},${var.ipv4s.node02},' --private-key ${var.ssh_keys_path.private} -e 'pub_key=${var.ssh_keys_path.public}' --extra-vars 'k8s_secret=${random_password.lower.result}.${random_password.upper.result}' ${path.module}/worker-node.yaml"
  }
}