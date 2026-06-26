# =============================================================================
# Prod-окружение
# =============================================================================

terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100"
    }
  }
  backend "s3" {}
}

provider "yandex" {}

module "prod_vm" {
  source = "../../modules/vm"

  vm_name         = var.vm_name
  cores           = var.cores
  memory          = var.memory
  disk_size       = var.disk_size
  disk_type       = var.disk_type
  zone            = var.zone
  subnet_id       = var.subnet_id
  ssh_public_key  = var.ssh_public_key
  ssh_user        = var.ssh_user
  nat             = var.nat
  platform_id     = var.platform_id

  labels = {
    environment = "prod"
    managed_by  = "terraform"
  }
}
