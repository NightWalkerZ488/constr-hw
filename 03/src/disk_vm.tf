# Создаём 3 диска по 1 Гб
resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name = "storage-disk-${count.index + 1}"
  type = "network-hdd"
  zone = var.default_zone
  size = 1 # 1 Гб
}

# 2. Создаём ВМ "storage"
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone

  # Минимальные ресурсы
  resources {
    cores  = 2
    memory = 2
  }

  # Ubuntu
  boot_disk {
    initialize_params {
      image_id = "fd804teg9bthv0h96s8v" 
      size     = 10
    }
  }

  # Сеть
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example_dynamic.id]
    nat                = true
  }

  # SSH ключ
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  # Прерываемая ВМ
  scheduling_policy {
    preemptible = true
  }

  # Подключение дисков через for_each
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk

    content {
      disk_id     = secondary_disk.value.id
      mode        = "READ_WRITE"
      auto_delete = false
    }
  }

  # ВМ создаётся после дисков
  depends_on = [yandex_compute_disk.storage_disk]
}
