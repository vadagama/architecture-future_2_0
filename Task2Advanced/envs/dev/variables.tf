# =============================================================================
# Dev — переменные
# =============================================================================
variable "vm_name"        { description = "Имя ВМ"; type = string }
variable "cores"          { description = "vCPU"; type = number }
variable "memory"         { description = "RAM (ГБ)"; type = number }
variable "disk_size"      { description = "Диск (ГБ)"; type = number }
variable "disk_type"      { description = "Тип диска"; type = string }
variable "zone"           { description = "Зона"; type = string }
variable "subnet_id"      { description = "ID подсети"; type = string }
variable "ssh_public_key" { description = "SSH-ключ"; type = string }
variable "ssh_user"       { description = "SSH-пользователь"; type = string }
variable "nat"            { description = "Публичный IP"; type = bool }
variable "platform_id"    { description = "Платформа"; type = string }
