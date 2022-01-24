# Terraforming
First, configure the provider with a valid qemu string, and configure your host to be able to access the remote.
For example, a `qemu+ssh` string should require pre-installed keys on the remote.

```sh
# This will show that will be done
terraform plan
# This will apply the changes
terraform apply
```

# Ansible
By default the `ansible` playbook will be run at the end of terraforming.
