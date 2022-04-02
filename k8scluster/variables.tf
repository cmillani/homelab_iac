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

variable "base" {
  type = object({
    base_image_pool = string
    base_image_name = string
    bridge_name = string
  })
}
variable "ipv4s" {
  type = object({
    kubeadm = string
    node01 = string
    node02 = string
  })
}