output "container_password" {
  value     = random_password.lxc_password.result
  sensitive = true
}