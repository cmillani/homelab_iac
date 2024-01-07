#########
resource "random_bytes" "cert_key" {
  length = 32
}

# Kubeadm secret must be format [a-z0-9]{6}.[a-z0-9]{16}
resource "random_password" "lower" {
  length = 6
  special = false
  upper = false
}
resource "random_password" "upper" {
  length = 16
  special = false
  upper = false
}

# Post install
resource "null_resource" "config_secrets" {
  triggers = {
    cert_key = random_bytes.cert_key.hex
    lower = random_password.lower.id
    upper = random_password.upper.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "k8s.cadumillani.com.br"
    type = "ssh"
    user = "carlos"
    private_key = file(var.ssh_keys_path.private)
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo kubeadm init phase upload-certs --upload-certs --certificate-key ${random_bytes.cert_key.hex}",
      "sudo kubeadm token create ${random_password.lower.result}.${random_password.upper.result}"
    ]
  }
}
