resource "yandex_compute_instance" "vm-gitlab-1" {
  name      = "gitlabwedunru"
  hostname  = "gitlab.wedun.ru"

  resources {
    cores  = 4
    core_fraction = 20
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address      = "192.168.10.26"
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-gitlab-runner-1" {
  name = "runnerwedunru"
  hostname  = "gitlab-runner.wedun.ru"

  resources {
    cores           = 2
    core_fraction   = 20
    memory          = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address      = "192.168.10.27"
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
  }
}
