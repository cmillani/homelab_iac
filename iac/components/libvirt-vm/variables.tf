# VM base image information

variable "base_volume_name" {
  type = string
  description = "Name of the base image"
}

# VM image information
variable "pool_name" {
  type = string
  description = "Name of the pool where vm image will be created"
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
variable "cinit_user_data_path" {
  type = string
  description = "Cloud Init path to use on VM"
}

variable "cinit_network_config_path" {
  type = string
  description = "Network config path to use on cloud init"
}

variable "ansible_path" {
  type = string
  description = "Path to ansible script that should be run after vm creation"
}

variable "ssh_keys_path" {
  type = object({
    public = string
    private = string
  })
  description = "Public and private keys path to be used for Ansible"
}

variable "ansible_extra_vars" {
  type = string
  default = ""
  description = "String to pass to ansible as value of `--extra-vars`. Should be of format 'key=value key2=value2' "
}
