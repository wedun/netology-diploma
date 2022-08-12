1.  Регистрация доменного имени
Зарегистрировал доменное имя и делегировал его в сервис Яндекс.Коннект.
Домен wedun.ru

2. Создание инфраструктуры  
Создали сервисный аккаунт "tfservice"  
Создали Backend "remote" в Terraform Cloud  
Создали Workspace "diploma-workspace-stage"  
Создали VPC с подсетями в разных зонах доступности  
Проверили, что команды 'terraform destroy' и 'terraform apply' выполняются без дополнительных ручных действий  
Проверили, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud  
![diploma-workspace-stage.png](diploma-workspace-stage.png)

## Terraform
Файлы конфигурации доступны по [ссылке](https://github.com/wedun/netology-diploma/tree/master/infra)

В файлах terraform вынесены параметры для каждого типа серверов:

- В файле main.tf описана конфигурация для reverce proxy и nat виртуальных машин.
- В файле mysql.tf описана конфигурация для mysql master и slave виртуальных машин.
- В файле gitlab.tf описана конфигурация для gitlab и gitlab-runner виртуальных машин.
- В файле app.tf описана конфигурация для виртуальной машины сервера приложений.
- В файле network.tf описана конфигурация для подсетей в которых размещаются виртуальные машины.
- В файле output.tf описана конфигурация для подключения к виртуальным машинам.
- В файле monitoring.tf описана конфигурация для настройки мониторинга виртуальных машин.

В Terraform Cloud добавим переменную окружения 'YC_TOKEN', в этой переменной сохраним токен подключения к Яндеккс.Облаку.

Выполним команду 'terraform apply -auto-approve' и проверим результат в Terraform Cloud
![diploma-workspace-stage-2.png](diploma-workspace-stage-2.png)

Проверим виртуальные машины в Яндекс.Облако
![yandex cloud vms.png](yandex cloud vms.png)

DNS зона в Яндекс.Облако
![auto-generated-dns-zone.png](auto-generated-dns-zone.png)

## Ansible

В репозитоии были созданы роли для каждого задания. Роли доступны по [ссылке](https://github.com/wedun/netology-diploma/tree/master/ansible/roles)

1. Установка кластера mysql
'ansible-galaxy role init database-slave-role' - эта роль устанавливает и настраивает slave ноду в кластере mysql

2. Установка общих ролей
ansible-galaxy role init common-role - эта роль устанавливает и настраивает сервисы, требуемые другим ролям (docker, node-exporter)

3. Установка Nginx и LetsEncrypt
'ansible-galaxy role init reverse-proxy-role' - эта роль устанавливает и настраивает nginx и certbot

4. Установка кластера mysql
'ansible-galaxy role init database-role' - эта роль устанавливает и настраивает master ноду в кластере mysql

5. Установка wordpress
'ansible-galaxy role init wordpress-role' - эта роль устанавливает и настраивает сайт на Wordpress

6. Установка Gitlab
'ansible-galaxy role init gitlab-role' - эта роль устанавливает и настраивает Gitlab

7. Установка Monitoring
'ansible-galaxy role init monitoring-role' - эта роль устанавливает и настраивает Alertmanager, Prometheus, Grafana

8. Установка Gitlab runner
'ansible-galaxy role init gitlab-runner-role' - эта роль устанавливает и настраивает Gitlab runner

Доступ к серверам в закрытой сети реализован через NAT инстанс в Яндекс.Облако и SSH JumpHost. Для запуска Ansible необходимо настроить SSH.
Добавим в '~/.ssh/config' сформированную ранее конфигурацию для подключения к виртуальным машинам
```bash
Host www.wedun.ru
  HostName 51.250.90.86
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
Host db01.wedun.ru
  HostName db01.wedun.ru
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.75.217
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
Host db02.wedun.ru
  HostName db02.wedun.ru
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.75.217
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
Host app.wedun.ru
  HostName app.wedun.ru
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.75.217
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
Host monitoring.wedun.ru
  HostName 192.168.10.11
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.75.217
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
Host gitlab.wedun.ru
  HostName 192.168.10.26
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.75.217
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
Host runner.wedun.ru
  HostName 192.168.10.27
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.75.217
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
```

В файл 'variables.yml' необходимо указать список IP адресов. Файл доступен по [ссылке](https://github.com/wedun/netology-diploma/blob/master/ansible/roles/variables.yml)
В файл 'prometheus.yml' необходимо указать список IP адресов. Файл доступен по [ссылке](https://github.com/wedun/netology-diploma/blob/master/ansible/roles/monitoring-role/files/prometheus/prometheus.yml)

Запускаем роли:
Reverse-proxy role:
```bash
PLAY RECAP *******************************************************************************************************
nginx_pool                 : ok=19   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

MySQL role:
```bash
PLAY RECAP *******************************************************************************************************
mysql_slave_pool           : ok=16   changed=14   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
mysql_master_pool          : ok=19   changed=14   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Wordpress role:
```bash
PLAY RECAP *******************************************************************************************************
wordpress_pool             : ok=27   changed=24   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Результат:
Установка wordpress  
![wordpress-1.png](wordpress-1.png)
Результат установки  
![wordpress-2.png](wordpress-2.png)

Gitlab и gitlab-runner role:
```bash
PLAY RECAP *******************************************************************************************************
gitlab_pool                : ok=11   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
gitlab_runner_pool         : ok=9    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

'gitlab-runner' настроим в ручном режиме. Токен и адрес сервера используем с портала 'https://gitlab.wedun.ru'

Содержимое .gitlab-ci.yml 
```bash
before_script:
  - eval $(ssh-agent -s)
  - echo "$ssh_key" | tr -d '\r' | ssh-add -
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh

deploy-job:
  stage: deploy
  script:
    - echo "Wordpress deploy" 
    # Upload to server
    - rsync -vz -e "ssh -o StrictHostKeyChecking=no" ./* /var/www/wordpress/
    - ssh -o StrictHostKeyChecking=no rm -rf /var/www/wordpress/.git
    # Provide file permissions
    - ssh -o StrictHostKeyChecking=no sudo chown -R www-data /var/www/wordpress/ 

```

Результат:
Опубликовали репозиторий  
![gitlab.png](gitlab.png)
Подключили Runner  
![gitlab-runner.png](gitlab-runner.png)

Monitoring
```
PLAY RECAP *******************************************************************************************************
monitoring_pool            : ok=14   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Проверим установленные роли:
Настроили Prometheus  
![prometheus.png](prometheus.png)
Настроили Grafana  
![grafana.png](grafana.png)
Настроили Alertmanager  
![alertmanager.png](alertmanager.png)