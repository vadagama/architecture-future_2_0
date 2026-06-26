variable "vm_name" {
  description = "Имя ВМ"
  type        = string
}
variable "cores" {
  description = "Количество vCPU"
  type        = number
}
variable "memory" {
  description = "RAM (ГБ)"
  type        = number
}
variable "disk_size" {
  description = "Размер диска (ГБ)"
  type        = number
}
variable "disk_type" {
  description = "Тип диска"
  type        = string
}
variable "zone" {
  description = "Зона доступности"
  type        = string
}
variable "subnet_id" {
  description = "ID подсети"
  type        = string
}
variable "ssh_public_key" {
  description = "Путь к публичному SSH-ключу"
  type        = string
}
variable "ssh_user" {
  description = "SSH-пользователь"
  type        = string
}
variable "nat" {
  description = "Назначить публичный IP"
  type        = bool
}
variable "platform_id" {
  description = "Платформа ВМ"
  type        = string
}
