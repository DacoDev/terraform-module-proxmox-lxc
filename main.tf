terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.43.0"
    }
  }
}
locals {
  container_template_file_insecure = contains(["https"], var.container_template_file) ? false : true
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
    dedicated = var.ram_MiB
    swap      = var.swap_MiB
  }
  disk {
    datastore_id = var.datastore_id
    size  = var.disk_size
  }
  network_interface {
    name = "veth0"
  }
  operating_system {
    template_file_id = proxmox_virtual_environment_file.container_template.id
    type             = var.distro
  }
}
resource "proxmox_virtual_environment_file" "container_template" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.node_name
  source_file {
    path     = var.container_template_file
    insecure = local.container_template_file_insecure
  }
}
resource "random_password" "lxc_password" {
  length           = var.password_length
  override_special = "_%@"
  special          = true
}