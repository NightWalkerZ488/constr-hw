# Создаём 2 ВМ
resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}" # web-1, web-2 (не 0 и 1!)
  platform_id = "standard-v1"
  zone        = var.default_zone

  # Ресурсы
  resources {
    cores  = 2
    memory = 2
  }

  # Образ
  boot_disk {
    initialize_params {
      image_id = "fd804teg9bthv0h96s8v"
      size     = 10
    }
  }

  # Сеть и группы безопасности
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example_dynamic.id]
    nat                = true
  }

  # SSH
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  # Прерываемая ВМ
  scheduling_policy {
    preemptible = true
  }

  depends_on = [yandex_compute_instance.db]
}
