include "root" {
  path = find_in_parent_folders()
}

dependency "pool" {
  config_path = "${get_terragrunt_dir()}/../pool"
}

include "base-image" {
  path = "${get_terragrunt_dir()}/../../_base/base-image.hcl"
}

include "ryzenlab" {
  path = "${get_terragrunt_dir()}/../../_base/ryzenlab-provider.hcl"
}