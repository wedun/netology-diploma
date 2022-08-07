resource "yandex_compute_instance" "vm-monitor-1" {
  name      = "monitoringwedunru"
  hostname  = "monitoring.wedun.ru"

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