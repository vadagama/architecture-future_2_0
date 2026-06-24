data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "testvm" {
  name = "test-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 15
}

resource "yandex_compute_instance" "testvm" {
  name = "test-vm"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.testvm.id
  }

  network_interface {
    subnet_id = "<< SUBNETID >>"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
