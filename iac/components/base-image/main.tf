terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

#########

resource "libvirt_volume" "image" {
  name   = var.image_name
  pool   = var.pool_name
  source = var.image_url
  format = var.image_file_type
}