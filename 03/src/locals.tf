locals {
  # Читаем публичный SSH ключ из файла
  ssh_public_key = file("~/.ssh/id_ed25519.pub")
}
