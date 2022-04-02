variable "ssh_keys_path" {
  type = object({
    public = string
    private = string
  })
  default = ({
    public = "~/.ssh/id_rsa.pub"
    private = "~/.ssh/id_rsa"
  })
  description = "Public and private keys path to be used for Ansible"
}

variable "vm_config" {
  type = object({
    ipv4 = string
    base_image_pool = string
    base_image_name = string
    bridge_name = string
  })
  description = "Base information for HASS VM creation. libvirt uri must match"
}