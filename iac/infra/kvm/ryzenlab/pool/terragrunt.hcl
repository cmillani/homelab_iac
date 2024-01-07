include "root" {
  path = find_in_parent_folders()
}

include "pool" {
  path = "${get_terragrunt_dir()}/../../_base/pool.hcl"
}

include "ryzenlab" {
  path = "${get_terragrunt_dir()}/../../_base/ryzenlab-provider.hcl"
}