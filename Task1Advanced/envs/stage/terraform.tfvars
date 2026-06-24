# =============================================================================
# Stage-окружение — значения переменных
# Средняя конфигурация, приближенная к продуктовой
# =============================================================================

vm_name        = "stage-vm"
cores          = 4
memory         = 8
disk_size      = 50
disk_type      = "network-ssd"
zone           = "ru-central1-b"
subnet_id      = "<< YOUR_SUBNET_ID >>"
ssh_public_key = "~/.ssh/id_rsa.pub"
ssh_user       = "ubuntu"
nat            = true
platform_id    = "standard-v2"
