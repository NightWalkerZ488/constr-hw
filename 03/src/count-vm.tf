resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores  = var.web_cores
    memory = var.web_memory
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

  depends_on = [yandex_compute_instance.db]
}
