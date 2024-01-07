terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

#########

resource "libvirt_volume" "vm_vol" {
  name   = var.image_name
  pool   = var.pool_name
  base_volume_name = var.base_volume_name
  base_volume_pool = var.pool_name
  size = var.disk_size
  format = "qcow2"
}

#########

resource "random_password" "password" {
  length = 16
  special = true
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit-${var.image_name}.iso"
  pool           = var.pool_name
  user_data      = templatefile("${var.cinit_user_data_path}", { 
    SSH_PUB_KEY: file(var.ssh_keys_path.public)
    USR_PASSWORD: "${random_password.password.bcrypt_hash}"
    HOSTNAME: "${var.image_name}"
  })
  network_config = templatefile("${var.cinit_network_config_path}", {
    IPV4_ADDR: "${var.ipv4_address}"
  })
}

#########

resource "libvirt_domain" "libvirt_vm" {
  name      = var.image_name
  vcpu      = var.vcpu
  memory    = var.memory

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    bridge = var.bridge_name
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.vm_vol.id
  }
}

# Post install
resource "null_resource" "post_install" {
  triggers = {
    vm_id = libvirt_domain.libvirt_vm.id
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.ipv4_address},' --private-key ${var.ssh_keys_path.private} -e 'pub_key=${var.ssh_keys_path.public}' --extra-vars \"${var.ansible_extra_vars}\" ${var.ansible_path}"
  }
}