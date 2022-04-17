terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
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

provider "aws" {
  region = "us-east-2"
}