terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.43.2"
    }
  }
}
locals {
  container_template_file_insecure = can(regex("^https:\\/\\/.*", var.container_template_file)) ? "false" : "true"
  container_template_file_download = (can(regex("^https?:\\/\\/.*", var.container_template_file)) && var.migrate_template_file == true) ? 1 : 0
  container_template_file_local    = (local.container_template_file_download == 0 || var.migrate_template_file == false) ? 1 : 0
  container_template               = (local.container_template_file_download == 1 && var.migrate_template_file == true) ? proxmox_virtual_environment_download_file.container_template[0].id : proxmox_virtual_environment_file.container_template[0].id
}

resource "proxmox_virtual_environment_container" "proxmox_lxc" {
  description = "Managed by Terraform"
  node_name   = var.node_name
  vm_id       = var.vm_id
  initialization {
    hostname = var.container_name
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      password = random_password.lxc_password.result
    }
  }
  cpu {
    architecture = "amd64"
    cores        = var.cpu_cores
  }
  memory {
    dedicated = var.memory_dedicated
    swap      = var.memory_swap
  }
  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }
  network_interface {
    name = "veth0"
  }
  operating_system {
    template_file_id = local.container_template
    type             = var.distro
  }
}
resource "proxmox_virtual_environment_file" "container_template" {
  count        = local.container_template_file_local
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.node_name
  source_file {
    path     = var.container_template_file
    insecure = local.container_template_file_insecure
  }
}

resource "proxmox_virtual_environment_download_file" "container_template" {
  count        = local.container_template_file_download
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.node_name
  url          = var.container_template_file
  overwrite    = true
  verify       = local.container_template_file_insecure == "true" ? "false" : "true"
}

resource "random_password" "lxc_password" {
  length           = var.password_length
  override_special = "_%@"
  special          = true
}
