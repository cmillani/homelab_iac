terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  alias = "homelab"
  uri = local.libvirt_uris.homelab
}

provider "libvirt" {
  alias = "ryzenlab"
  uri = local.libvirt_uris.ryzenlab
}