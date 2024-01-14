module "proxmox-lxc-debian-multiple" {
  source                  = "DacoDev/proxmox-lxc/module"
  count                   = 3
  container_name          = "debian-${count.index + 1}"
  container_template_file = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
  cpu_cores               = 4
  distro                  = "debian"
  node_name               = "proxmox-example"
  memory_dedicated        = 4096
  vm_id                   = (1000 + count.index)
  disk_size               = 20
}