output "volume_name" {
    value = libvirt_volume.image.name
}

output "pool_name" {
    value = libvirt_pool.pool.name
}