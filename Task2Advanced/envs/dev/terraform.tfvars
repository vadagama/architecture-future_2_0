# =============================================================================
# Dev — значения (минимальная конфигурация для разработки)
# =============================================================================
vm_name        = "dev-vm"
cores          = 2
memory         = 2
disk_size      = 15
disk_type      = "network-hdd"
zone           = "ru-central1-a"
subnet_id      = "<< YOUR_SUBNET_ID >>"
ssh_public_key = "~/.ssh/id_rsa.pub"
ssh_user       = "ubuntu"
nat            = true
platform_id    = "standard-v1"
