# Выполнено ДЗ №10

 - [x] Основное ДЗ
 - [x] Задание со *
 - [x] Задание с **

## В процессе сделано:

 - подготовлен плейбук для установки Nginx-а
 - запуск плейбука производится при помощи соответствующего provisioner-а вагранта (позволяет не задумываться о портах (см. блок с проблемами, ключах и т.п.)

 - (*)
 - подготовлена роль для установки Nginx - переменные, таски, хендлеры разнесены по блоками роли.

 - (**)
 - реализована возможность тестов при помощи фреймворка Molecule
 - роль скорректирована по замечаниям линтеров, в частности указана конкретная версия Nginx-а
 - для разнообразия инфраструктурные тесты написаны при помощи Goss-а
   - проверка установлен ли nginx
   - проверка запущен ли nginx и находится ли сервис в состоянии enabled
 

## Как проверить

 - Простое задание
   - Указать в Vagrantfile плейбук nginx.yml
   - vagrant up
   - curl http://127.0.0.1:8080

 - Звездочка
   - Указать в Vagrantfile плейбук nginx_role.yml (в репозитории указан именно он)
   - vagrant up
   - curl http://localhost:8080

 - Две звездочки
   - cd roles/my-nginx/
   - molecule test (приложен скрин прохождения теста - session-molecule.log)


## Проблемы при выполнении задания
 - Не проходит коннект к хосту при запуске плейбука извне ансибла (указан неверный порт)
   - необходимо обращать внимание по какому порту работает vagrant ssh, стандартный 2222-порт может быть занят другой машиной

 - При запуске плейбука молекулой, на этапе рестарта сервиса возникает ошибка: Failed to get D-Bus connection: Operation not permitted
   - докеру нужно больше привелегий, решается добавлением соответствующих команд в molecule.yml
   ```
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    capabilities:
      - SYS_ADMIN
    command: /sbin/init
   ```