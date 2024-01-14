module "proxmox-lxc-debian-remote" {
  source                  = "DacoDev/proxmox-lxc/module"
  container_name          = "debian"
  container_template_file = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
  cpu_cores               = 2
  distro                  = "debian"
  node_name               = "proxmox-example"
  memory_dedicated        = 512
  vm_id                   = 1001
  disk_size               = 20
}