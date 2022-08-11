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

В репозитоии были созданы роли для каждого задания

3. Установка Nginx и LetsEncrypt
ansible-galaxy init reverse-proxy-role

4. Установка кластера mysql
ansible-galaxy init database-role

5. Установка wordpress
ansible-galaxy role init wordpress-role

6. Установка Gitlab
ansible-galaxy role init gitlab-role

7. Установка Monitoring
ansible-galaxy role init monitoring-role