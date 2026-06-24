# =============================================================================
# vm_module — выходные значения
# =============================================================================

output "vm_id" {
  description = "Идентификатор виртуальной машины"
  value       = yandex_compute_instance.vm.id
}
output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}
output "vm_fqdn" {
  description = "FQDN виртуальной машины"
  value       = yandex_compute_instance.vm.fqdn
}
output "external_ip" {
  description = "Внешний IP-адрес ВМ (пустая строка, если NAT выкл)"
  value = (
    length(yandex_compute_instance.vm.network_interface) > 0
    ? try(yandex_compute_instance.vm.network_interface[0].nat_ip_address, "")
    : ""
  )
}
output "internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value = (
    length(yandex_compute_instance.vm.network_interface) > 0
    ? yandex_compute_instance.vm.network_interface[0].ip_address
    : ""
  )
}
output "disk_id" {
  description = "Идентификатор загрузочного диска"
  value       = yandex_compute_disk.boot.id
}
output "disk_size" {
  description = "Размер загрузочного диска (ГБ)"
  value       = yandex_compute_disk.boot.size
}
output "zone" {
  description = "Зона доступности"
  value       = yandex_compute_instance.vm.zone
}
