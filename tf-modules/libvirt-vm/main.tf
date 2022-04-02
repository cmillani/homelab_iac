terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

#########

resource "libvirt_volume" "vm_vol" {
  name   = var.image_name
  pool   = var.base_image_pool_name
  base_volume_name = var.base_volume_name
  base_volume_pool = var.base_image_pool_name
  size = var.disk_size
  format = "qcow2"
}

#########

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit-${var.image_name}.iso"
  pool           = var.base_image_pool_name
  user_data      = var.cinit_user_data
  network_config = var.cinit_network_config
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