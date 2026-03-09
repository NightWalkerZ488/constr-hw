# 1. Создаём 3 диска
resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name = "storage-disk-${count.index + 1}"
  type = var.storage_disk_type
  zone = var.default_zone
  size = var.storage_disk_size
}

# 2. Создаём ВМ "storage"
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores  = var.storage_cores
    memory = var.storage_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.boot_disk_size
    }
  }

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image_id
    ]
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example_dynamic.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk

    content {
      disk_id     = secondary_disk.value.id
      mode        = var.disk_attach_mode
      auto_delete = var.disk_auto_delete
    }
  }

  depends_on = [yandex_compute_disk.storage_disk]
}
