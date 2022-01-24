terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://carlos@192.168.1.5/system"
}

#########

resource "libvirt_pool" "home_assistant" {
  name = "home_assistant"
  type = "dir"
  path = "/home/carlos/volumes"
}

resource "libvirt_volume" "home_assistant-qcow2" {
  name   = "homeassistant-qcow2"
  pool   = libvirt_pool.home_assistant.name
  base_volume_name = "debian-cloud-qcow2"
  base_volume_pool = "base_images"
  size = 21474836480
  format = "qcow2"
}

#########
variable "ipv4_address" {
  type        = string
  default     = "192.168.1.116"
  description = "IPV4 Address to be assigned to the new VM"
}

variable "private_key_path" {
  type        = string
  default     = "/home/carlos/.ssh/id_rsa"
  description = "Private key to be used to ssh into guests"
}

variable "public_key_path" {
  type        = string
  default     = "/home/carlos/.ssh/id_rsa.pub"
  description = "Public key to be installed to guests"
}

#########

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  pool           = libvirt_pool.home_assistant.name
  user_data      = templatefile("${path.module}/cloud_init.cfg", { 
    SSH_PUB_KEY: file(var.public_key_path)
  })
  network_config = templatefile("${path.module}/network_config.cfg", {
    IPV4_ADDR: var.ipv4_address
  })
}

#########

resource "libvirt_domain" "homeassistant" {
  name      = "homeassistant"
  vcpu      = 1
  memory    = "512"

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    bridge = "kvm_br0"
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
    volume_id = libvirt_volume.home_assistant-qcow2.id
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.ipv4_address},' --private-key ${var.private_key_path} -e 'pub_key=${var.public_key_path}' hass-install.yml"
  }
}