resource "yandex_compute_instance" "vm-app-1" {
  name      = "appwedunru"
  hostname  = "app.wedun.ru"

  resources {
    cores           = 2
    core_fraction   = 20
    memory          = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}