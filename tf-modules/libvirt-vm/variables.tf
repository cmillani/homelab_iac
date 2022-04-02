# VM base image information
variable "base_image_pool_name" {
  type = string
  description = "Name of the pool where base image is located"
}

variable "base_volume_name" {
  type = string
  description = "Name of the base image"
}

# VM image information
variable "pool_name" {
  type = string
  default = "iac"
  description = "Name of the pool where vm image will be created"
}

variable "pool_path" {
  type = string
  default = "/home/carlos/iac"
  description = "Path to use as image pool"
}

variable "image_name" {
  type = string
  description = "Name of the VM image"
}

# VM configuration
variable "disk_size" {
  type = number
  description = "Size of disk in bytes"
}

variable "vcpu" {
  type = number
  description = "Number of vcpus of the VM"
}

variable "memory" {
  type = string
  description = "Memory of the VM in MB"
}

variable "ipv4_address" {
  type = string
  description = "IPV4 Address to be assigned to the new VM"
}

variable "bridge_name" {
  type = string
  description = "Bridge name on host to connect VM to"
}

# Cloud init
variable "cinit_user_data" {
  type = string
  description = "Cloud Init data to use on VM"
}

variable "cinit_network_config" {
  type = string
  description = "Network config to use on cloud init"
}