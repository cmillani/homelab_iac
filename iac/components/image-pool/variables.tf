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
