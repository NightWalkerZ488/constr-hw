###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

# Переменная для получения актуального образа Ubuntu 22.04 LTS
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "platform_id" {
  description = "Платформа для ВМ"
  type        = string
  default     = "standard-v1"
}

variable "web_cores" {
  description = "Количество ядер для web ВМ"
  type        = number
  default     = 2
}

# === Переменные для storage ВМ ===
variable "storage_cores" {
  description = "Количество ядер для storage ВМ"
  type        = number
  default     = 2
}

variable "storage_memory" {
  description = "Объем памяти для storage ВМ"
  type        = number
  default     = 2
}

# === Переменные для дисков ===
variable "storage_disk_type" {
  description = "Тип дисков для storage"
  type        = string
  default     = "network-hdd"
}

variable "storage_disk_size" {
  description = "Размер дополнительных дисков (Гб)"
  type        = number
  default     = 1
}

variable "disk_attach_mode" {
  description = "Режим подключения диска"
  type        = string
  default     = "READ_WRITE"
}

variable "disk_auto_delete" {
  description = "Автоматическое удаление диска при удалении ВМ"
  type        = bool
  default     = false
}

variable "web_memory" {
  description = "Объем памяти для web ВМ"
  type        = number
  default     = 2
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска"
  type        = number
  default     = 10
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))

  description = "Параметры ВМ для баз данных"

  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 8
      disk_volume = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 4
      disk_volume = 15
    }
  ]
}
