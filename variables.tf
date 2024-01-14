variable "distro" {
  description = "Selection of the QEMU agent that will be used with the container. Options: alpine, archlinux, centos, debian, fedora, gentoo, opensuse, ubuntu, unmanaged"
  type        = string
  validation {
    condition     = contains(["alpine", "archlinux", "centos", "debian", "fedora", "gentoo", "opensuse", "ubuntu", "unmanaged"], var.distro)
    error_message = "The distro var should contain one of alpine, archlinux, centos, debian, fedora, gentoo, opensuse, ubuntu, unmanaged."
  }
}
variable "node_name" {
  description = "The name of the specific ProxMox node that the container/s will be spun up on."
  type        = string
  validation {
    condition     = can(regex("[A-Za-z0-9.-]{1,63}", var.node_name))
    error_message = "This var is constrained by the node name requirements set forth by ProxMox."
  }
}
variable "container_template_file" {
  description = "A .tar.zst/.tar.gz/.tar.xz as found at https://us.lxd.images.canonical.com/images/ or http://download.proxmox.com/images/system/. Container templates pre-downloaded to the Terraform-running machine can also be used."
  type        = string
  validation {
    condition     = can(regex("(https?:\\/\\/(.*)\\.(tar\\.gz|tar\\.zst|tar\\.xz))|(([^\\0]+\\.((tar\\.gz)|(tar\\.zst)|(tar\\.xz))))", var.container_template_file))
    error_message = "URL should start with HTTP or HTTPS and end with one of .tar.gz, .tar.zst, or .tar.xz. Local file paths should be absolute and start with a /."
  }
}
variable "datastore_id" {
  description = "The drive where the container's root storage will be created. The size of the root volume is current limited to the size of the base image due to a current limitation in the provider this is using."
  type        = string
  default     = "local-lvm"
}
variable "disk_size" {
  type    = number
  default = 4
  validation {
    condition     = can(regex("[0-9]+", var.disk_size))
    error_message = "Set the size of the LXC disk in GB"
  }
}
variable "memory_dedicated" {
  description = "Amount of RAM to provision for each container, in MegaBytes."
  type        = number
  default     = 512
  validation {
    condition     = can(regex("[0-9]+", var.memory_dedicated))
    error_message = "Numbers only, no limit currently but maybe it won't work."
  }
}
variable "memory_swap" {
  description = "By setting this value, you grant access for the container to use the host node SWAP space, 0 by default."
  type        = number
  default     = 0
  validation {
    condition     = can(regex("[0-9]+", var.memory_swap))
    error_message = "Numbers only, no limit currently but maybe it won't work."
  }
}
variable "vm_id" {
  description = "The VM ID to assign, if count is greater than 1, the VM ID iterates by 1 for each host. ex: count=3,vm_id=100, would give you VM IDs 100, 101, 102"
  type        = number
  validation {
    condition     = can(regex("^([1-9][0-9]{1,8}|[1-2][0-9]{9}|214748364[0-7])$", var.vm_id))
    error_message = "Can contain a number between 100 and 2147483647."
  }
}
variable "container_name" {
  description = "The name or name-prefix of the container if count is specified. With count, name prefix would become 'example-1', 'example-2', etc"
  type        = string
  validation {
    condition     = can(regex("[A-Za-z0-9.-]{1,63}", var.container_name))
    error_message = "Has to conform with RFC defined hostname characters and length, may fail if it's a prefix with enough chars to overflow the total of 63."
  }
}
variable "cpu_cores" {
  description = "Number of cores to make available to the container (based on the threaded core count)"
  type        = number
  validation {
    condition     = can(regex("[0-9]{1,}", var.cpu_cores))
    error_message = "Must contain a number of 1 or more."
  }
}
variable "cpu_units" {
  description = "This is a relative weight passed to the kernel scheduler. The larger the number is, the more CPU time this container gets. Number is relative to the weights of all the other running containers."
  type        = number
  default     = 1024
  validation {
    condition     = can(regex("[0-9]+", var.cpu_units))
    error_message = "Numbers only, not sure what the limit is."
  }
}
variable "password_length" {
  description = "Length of the randomly generated password."
  type        = number
  default     = 16
}
variable "migrate_template_file" {
  description = "Set to false to prevent re-creating the underlying proxmox_virtual_environment_file."
  type        = bool
  default     = true
}