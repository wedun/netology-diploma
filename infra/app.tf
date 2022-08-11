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
      image_id   = "fd81d2d9ifd50gmvc03g"
      size       = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address      = "192.168.10.15"
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}
