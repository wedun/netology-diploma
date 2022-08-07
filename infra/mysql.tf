resource "yandex_compute_instance" "vm-db-1" {
  name      = "db01wedunru"
  hostname  = "db01.wedun.ru"

  resources {
    cores         = 4
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
    }
  }

  network_interface {
    subnet_id	   = yandex_vpc_subnet.subnet-1.id
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-db-2" {
  name      = "db02wedunru"
  hostname  = "db02.wedun.ru"

  resources {
    cores         = 4
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
    }
  }

  network_interface {
    subnet_id	   = yandex_vpc_subnet.subnet-1.id
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}
