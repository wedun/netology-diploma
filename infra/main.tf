resource "yandex_compute_instance" "vm-1" {
  name      = "wedunru"
  hostname  = "www.wedun.ru"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 10
    }
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.subnet-1.id
    nat             = true
    nat_ip_address  = "51.250.90.86"
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-nat-1" {
  name     = "natwedunru"
  hostname = "nat.wedun.ru"
  zone     = "ru-central1-a"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8josjq21d56924jfan"
    }
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.subnet-1.id
    nat             = true
    nat_ip_address  = "51.250.75.217"
    ip_address 	    = "192.168.10.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./id_rsa.pub")}"
  }
}
