include "root" {
  path = find_in_parent_folders()
}

dependency "pool" {
  config_path = "${get_terragrunt_dir()}/../pool"
}

include "base-image" {
  path = "${get_terragrunt_dir()}/../../_base/base-image.hcl"
}

include "homelab" {
  path = "${get_terragrunt_dir()}/../../_base/homelab-provider.hcl"
}