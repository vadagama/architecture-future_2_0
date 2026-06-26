output "vm_id"        { description = "ID ВМ"; value = module.prod_vm.vm_id }
output "vm_name"      { description = "Имя ВМ"; value = module.prod_vm.vm_name }
output "external_ip"  { description = "Внешний IP"; value = module.prod_vm.external_ip }
output "internal_ip"  { description = "Внутренний IP"; value = module.prod_vm.internal_ip }
output "disk_id"      { description = "ID диска"; value = module.prod_vm.disk_id }
