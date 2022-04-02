locals {
    disk_sz = 10737418240 # 10GB
    ssh_keys_path = {
        public = "~/.ssh/id_rsa.pub"
        private = "~/.ssh/id_rsa"
    }
    bridge_name = "kvm_br0"
    ipv4s = {
        control = "192.168.1.119"
        worker01 = "192.168.1.120"
        worker02 = "192.168.1.121"
    }
    libvirt_uris = {
        homelab = "qemu+ssh://carlos@192.168.1.5/system"
        ryzenlab = "qemu+ssh://carlos@192.168.1.6/system"
    }
}