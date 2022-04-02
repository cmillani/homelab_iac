# Pool information
variable "pool_path" {
  type = string
  default = "/home/carlos/iac"
  description = "Path to use as image pool"
}

variable "pool_name" {
  type = string
  default = "iac"
  description = "Name of the pool to be used"
}

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