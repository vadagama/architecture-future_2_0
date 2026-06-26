# =============================================================================
# Prod-окружение — значения переменных
# Высокопроизводительная конфигурация для промышленной эксплуатации
# =============================================================================

vm_name        = "prod-vm"
cores          = 8
memory         = 16
disk_size      = 100
disk_type      = "network-ssd-io-m3"
zone           = "ru-central1-a"
subnet_id      = "<< YOUR_SUBNET_ID >>"
ssh_public_key = "~/.ssh/id_rsa.pub"
ssh_user       = "ubuntu"
nat            = false
platform_id    = "standard-v3"
