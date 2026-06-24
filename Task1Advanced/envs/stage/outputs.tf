# =============================================================================
# Stage-окружение — выходные значения
# =============================================================================

output "vm_id"        { description = "ID созданной ВМ"; value = module.stage_vm.vm_id }
output "vm_name"      { description = "Имя созданной ВМ"; value = module.stage_vm.vm_name }
output "external_ip"  { description = "Внешний IP ВМ"; value = module.stage_vm.external_ip }
output "internal_ip"  { description = "Внутренний IP ВМ"; value = module.stage_vm.internal_ip }
output "disk_id"      { description = "ID загрузочного диска"; value = module.stage_vm.disk_id }
