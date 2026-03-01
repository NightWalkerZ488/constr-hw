# ВМ для БД
resource "yandex_compute_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = "db-${each.value.vm_name}"
  platform_id = "standard-v1"
  zone        = var.default_zone

  # Ресурсы
  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  # Диск
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

  # SSH
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  # Прерываемая ВМ
  scheduling_policy {
    preemptible = true
  }

}
