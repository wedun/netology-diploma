output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_db_1" {
  value = yandex_compute_instance.vm-db-1.network_interface.0.ip_address
}

output "external_ip_address_vm_db_2" {
  value = yandex_compute_instance.vm-db-2.network_interface.0.ip_address
}

output "ssh_config" {
  value = <<-EOT
  Host www.wedun.ru
    HostName ${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
  Host db01.wedun.ru
    HostName ${yandex_compute_instance.vm-db-1.network_interface.0.ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
      ProxyJump centos@${yandex_compute_instance.vm-nat-1.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
  Host db02.wedun.ru
    HostName ${yandex_compute_instance.vm-db-2.network_interface.0.ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
      ProxyJump centos@${yandex_compute_instance.vm-nat-1.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
  Host app.wedun.ru
    HostName ${yandex_compute_instance.vm-app-1.network_interface.0.ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
      ProxyJump centos@${yandex_compute_instance.vm-nat-1.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
  Host monitoring.wedun.ru
    HostName ${yandex_compute_instance.vm-monitor-1.network_interface.0.ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
      ProxyJump centos@${yandex_compute_instance.vm-nat-1.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
  Host gitlab.wedun.ru
    HostName ${yandex_compute_instance.vm-gitlab-1.network_interface.0.ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
      ProxyJump centos@${yandex_compute_instance.vm-nat-1.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
  Host runner.wedun.ru
    HostName ${yandex_compute_instance.vm-gitlab-runner-1.network_interface.0.ip_address}
    User centos
    IdentityFile ~/.ssh/id_rsa
      ProxyJump centos@${yandex_compute_instance.vm-nat-1.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
  EOT
}