module "3_debian_lxcs" {
  source                  = "DacoDev/proxmox-lxc/module"
  version                 = "1.0.0"
  distro                  = "debian"
  container_name          = "debian-k8s-lxc"
  node_name               = "example"
  container_template_file = "http://download.proxmox.com/images/system/debian-11-standard_11.3-1_amd64.tar.zst"
  cpu_cores               = 2
  ram_MiB                 = 2000
  swap_MiB                = 2000
  vm_id                   = 1000
}