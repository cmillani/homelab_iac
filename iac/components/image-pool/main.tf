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