# =============================================================================
# vm_module — переменные модуля
# =============================================================================

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}
variable "cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}
variable "memory" {
  description = "Объём оперативной памяти (ГБ)"
  type        = number
  default     = 2
}
variable "disk_size" {
  description = "Размер загрузочного диска (ГБ)"
  type        = number
  default     = 15
}
variable "disk_type" {
  description = "Тип диска"
  type        = string
  default     = "network-ssd"
}
variable "zone" {
  description = "Зона доступности Yandex Cloud"
  type        = string
}
variable "subnet_id" {
  description = "Идентификатор подсети"
  type        = string
}
variable "image_family" {
  description = "Семейство образа ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}
variable "ssh_public_key" {
  description = "Путь к файлу публичного SSH-ключа"
  type        = string
}
variable "ssh_user" {
  description = "Имя пользователя для SSH"
  type        = string
  default     = "ubuntu"
}
variable "nat" {
  description = "Назначить публичный IP (NAT)"
  type        = bool
  default     = true
}
variable "platform_id" {
  description = "Аппаратная платформа ВМ"
  type        = string
  default     = "standard-v1"
}
variable "labels" {
  description = "Метки (labels)"
  type        = map(string)
  default     = {}
}
