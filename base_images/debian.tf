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

resource "libvirt_pool" "base_images" {
  name = "base_images"
  type = "dir"
  path = "/home/carlos/base"
}

resource "libvirt_volume" "debian-cloud" {
  name   = "debian-cloud-qcow2"
  pool   = libvirt_pool.base_images.name
  source = "http://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu-cloud" {
  name   = "ubuntu-cloud-qcow2"
  pool   = libvirt_pool.base_images.name
  source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}