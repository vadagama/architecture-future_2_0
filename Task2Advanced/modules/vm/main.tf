# =============================================================================
# vm_module — основной код модуля
# =============================================================================

data "yandex_compute_image" "os" {
  family = var.image_family
}

resource "yandex_compute_disk" "boot" {
  name     = "${var.vm_name}-disk"
  type     = var.disk_type
  zone     = var.zone
  image_id = data.yandex_compute_image.os.image_id
  size     = var.disk_size

  labels = var.labels
}

resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  zone        = var.zone
  platform_id = var.platform_id

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }

  labels = var.labels
}
