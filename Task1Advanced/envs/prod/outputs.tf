# =============================================================================
# Prod-окружение — выходные значения
# =============================================================================

output "vm_id"        { description = "ID созданной ВМ"; value = module.prod_vm.vm_id }
output "vm_name"      { description = "Имя созданной ВМ"; value = module.prod_vm.vm_name }
output "external_ip"  { description = "Внешний IP ВМ"; value = module.prod_vm.external_ip }
output "internal_ip"  { description = "Внутренний IP ВМ"; value = module.prod_vm.internal_ip }
output "disk_id"      { description = "ID загрузочного диска"; value = module.prod_vm.disk_id }
