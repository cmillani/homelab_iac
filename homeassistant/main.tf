terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

# Modules

module "libvirt-vm" {
  source = "../tf-modules/libvirt-vm"

  base_image_pool_name = var.vm_config.base_image_pool
  base_volume_name  = var.vm_config.base_image_name

  image_name = "homeassistant"

  disk_size = 21474836480 # 20 GB
  ipv4_address = var.vm_config.ipv4
  vcpu = 1
  memory = "512"
  cinit_user_data      = templatefile("${path.module}/cloud_init.cfg", { 
    SSH_PUB_KEY: file(var.ssh_keys_path.public)
  })
  cinit_network_config = templatefile("${path.module}/network_config.cfg", {
    IPV4_ADDR: var.vm_config.ipv4
  })
  bridge_name = var.vm_config.bridge_name
}

# Post install
resource "null_resource" "post_install" {
  triggers = {
    vm_id = module.libvirt-vm.id
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.vm_config.ipv4},' --private-key ${var.ssh_keys_path.private} -e 'pub_key=${var.ssh_keys_path.public}' ${path.module}/hass-install.yml"
  }
}