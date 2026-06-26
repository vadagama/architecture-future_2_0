# =============================================================================
# Dev — выходные значения
# =============================================================================
output "vm_id"        { description = "ID ВМ"; value = module.dev_vm.vm_id }
output "vm_name"      { description = "Имя ВМ"; value = module.dev_vm.vm_name }
output "external_ip"  { description = "Внешний IP"; value = module.dev_vm.external_ip }
output "internal_ip"  { description = "Внутренний IP"; value = module.dev_vm.internal_ip }
output "disk_id"      { description = "ID диска"; value = module.dev_vm.disk_id }
