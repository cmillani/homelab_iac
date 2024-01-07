# Base image information
variable "image_name" {
  type = string
  default = "debian-cloud-qcow2"
  description = "Image name to be saved on pool"
}

variable "image_url" {
  type = string
  default = "http://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
  description = "URL to dowload image from"
}

variable "image_file_type" {
  type = string
  default = "qcow2"
  description = "Type of the file to be downloaded from 'var.image_url'"
}

variable "pool_name" {
  type = string
  description = "Name of the pool to be used to store image"
}