variable "distro" {
  description = "Selection of the QEMU agent that will be used with the container."
  type        = string
  validation {
    condition = contains(["alpine", "archlinux", "centos", "debian", "fedora", "gentoo", "opensuse", "ubuntu", "unmanaged"], var.distro)
  }
}
variable "node_name" {
  description = "The name of the specific ProxMox node that the container/s will be spun up on."
  type        = string
  validation {
    condition = can(regex("[A-Za-z0-9.-]{1,63}", var.node_name))
  }
}
variable "pve_container_template_file" {
  # todo: figure out local pathing for pre-downloaded 
  description = "A .tar.zst/.tar.gz/.tar.xz as found at https://us.lxd.images.canonical.com/images/ or http://download.proxmox.com/images/system/"
  type        = string
  validation {
    condition = can(regex("(http|https):\\/\\/(.*)(.tar.gz|.tar.zst|.tar.xz)", var.container_name))
  }
}
variable "datastore_id" {
  description = "The drive where the container's root storage will be created. The size of the root volume is current limited to the size of the base image due to a current limitation in the provider this is using."
  type        = string
  default     = "local-lvm"
}
variable "ram_MiB" {
  description = "Amount of RAM to provision for each container, in MebiBytes."
  type        = number
  validation {
    condition = can(regex("[0-9]+", var.ram_MiB))
  }
}
variable "swap_MiB" {
  description = "By setting this value, you grant access for the container to use the host node SWAP space, 0 by default."
  type        = number
  default     = 0
  validation {
    condition = can(regex("[0-9]+", var.swap_MiB))
  }
}
variable "vm_id" {
  description = "The VM ID to assign, if count is greater than 1, the VM ID iterates by 1 for each host. ex: count=3,vm_id=100, would give you VM IDs 100, 101, 102"
  type        = number
  validation {
    condition = can(regex("[0-9]{1,9}", var.container_name))
  }
}
variable "container_name" {
  description = "The name or name-prefix of the container if count is specified. With count, name prefix would become 'example-1', 'example-2', etc"
  type        = string
  validation {
    condition = can(regex("[A-Za-z0-9.-]{1,63}", var.container_name))
  }
}
variable "cpu_cores" {
  description = "Number of cores to make available to the container (based on the threaded core count)"
  type        = number
  validation {
    condition = can(regex("[0-9]{1,}"), var.cpu_cores)
  }
}
variable "cpu_units" {
  description = "This is a relative weight passed to the kernel scheduler. The larger the number is, the more CPU time this container gets. Number is relative to the weights of all the other running containers."
  type        = number
  default     = 1024
  validation {
    condition = can(regex("[0-9]+", var.cpu_units))
  }
}