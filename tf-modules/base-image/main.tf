terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

#########

resource "libvirt_pool" "pool" {
  name = var.pool_name
  type = "dir"
  path = var.pool_path
}

resource "libvirt_volume" "image" {
  name   = var.image_name
  pool   = libvirt_pool.pool.name
  source = var.image_url
  format = var.image_file_type
}