# Переменные для сбора данных о ВМ
locals {
  # Веб-серверы
  webservers = [
    for instance in yandex_compute_instance.web :
    {
      name        = instance.name
      external_ip = instance.network_interface.0.nat_ip_address
      fqdn        = instance.fqdn
    }
  ]

  # Базы данных
  databases = [
    for instance in yandex_compute_instance.db :
    {
      name        = instance.name
      external_ip = instance.network_interface.0.nat_ip_address
      fqdn        = instance.fqdn
    }
  ]

  # Хранилище
  storage = [
    {
      name        = yandex_compute_instance.storage.name
      external_ip = yandex_compute_instance.storage.network_interface.0.nat_ip_address
      fqdn        = yandex_compute_instance.storage.fqdn
    }
  ]
}

# Генерация inventory-файла
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content = templatefile("${path.module}/ansible_inventory.tpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
}

# Output
output "inventory_file_path" {
  description = "Path to generated Ansible inventory file"
  value       = local_file.ansible_inventory.filename
}
