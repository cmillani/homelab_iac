# This Repo
This repository holds the evolution of IaC on my homelab, and works as an experiment bench.
My final goal is to provide my whole infrastructure as code, there are steps to learn and much code to write until :)

Do not expect best practices in this repository (at least for now): since these are my first steps on IaC, I am following guidelines and documentations the best I can, but my first goal is to provide a working base. 

UPDATE: Reorganized folders to better follow Terraform's root and modules structure.
UPDATE: Using terragrunt to make it easier to add new nodes, still need to figure out how to handle longhorn volumes

# Using

First, configure the provider with a valid qemu string, and configure your host to be able to access the remote.
For example, a `qemu+ssh` string should require pre-installed keys on the remote.
Fill those informations on `locals.tf`

Also, setup aws credentials, using aws cli you can use the following, inputting valid IAM credentials:

```sh
aws configure
```

Terragrunt can run on each folder, or whole infra:
```sh
# whole infra
terragrunt
# This will apply the changes
terraform apply
```

# Roadmap

- [x] Simple VM Provisioning
- [x] Automatic k8s cluster creation (kubeadm)
- [x] Remote state (s3)
- [x] Reuse IaC (terragrunt?)
- [ ] Automatic k8s cluster population
- [ ] PXE - IaC on baremetal

# Interests
 
* Smart cluster - Every VM is statically assigned to a host. How could that be improved? (Maybe Ganeti? VSphere Cluster?)
