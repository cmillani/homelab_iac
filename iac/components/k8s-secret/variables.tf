variable "ssh_keys_path" {
  type = object({
    public = string
    private = string
  })
  description = "Public and private keys path to be used for SSH"
}