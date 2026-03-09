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
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image_id
    ]
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
