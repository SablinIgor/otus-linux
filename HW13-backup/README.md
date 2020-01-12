# Выполнено ДЗ №13

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:

### Настройка архивирования при помощи утилиты borg

Стенд состоит из двух виртуальных машин - server и client, которые поднимаются при помощи Vagrant.

ВМ server используется как серверная часть borg-а - для управления и хранения резервных копий.

ВМ client запускает резервное копирование каталога /etc раз в пять минут через задание cron-а.

**Детали реализации**

При старте виртуальных машин на них запускатся набор скриптов, характерных для типа виртуалки, определенные в описании Vagrantfile.

Для server - скрипты commonscript и serverscript.

Для client - скрипты commonscript и clientscript.

Скрипт commonscript содержит:

- обновление репозитория yum
- установку утилиты borg

Скрипт serverscript содержит:

- создание пользователя borg для управления репозиторием
- установка для пользователя borg публичной части ключа (otuslab.pub)

Скрипт clientscript содержит:

- установка пользователю root приватной части ключа (otuslab)
- инициализация репозитория borg с использованием шифрования (* - задание со звездочкой)
- настройка cron-а - запуск каждые 5 минут архивирования каталога /etc

Скрипт архивирования находится в файле borg_backup_files.sh.

Настройка cron-а находится в файле schedule.ы

### Как проверить работоспособность

```bash
vagrant up
(...после запуска подождать 10-15 минут, чтобы накопились резервные копии...)
vagrant ssh server
sudo su borg -l
borg list MyBorgRepo/ (...пароль myrepo...)
```

В результате должны увидеть что-то вроде:

```bash
[borg@server ~]$ borg list MyBorgRepo/
Enter passphrase for key /home/borg/MyBorgRepo: 
files-2020-01-12_16:30:03            Sun, 2020-01-12 16:30:05 [0d54dca3af07f4481f15b127e643892d60bef1415804c7448f3454853194abe0]
files-2020-01-12_16:35:02            Sun, 2020-01-12 16:35:05 [d21ff0d2431389f5c7520d9da908caecc97909969d1a51f27cc302b19e79ce75]
```

### Использованные источники

https://borgbackup.readthedocs.io/en/stable/
https://community.hetzner.com/tutorials/install-and-configure-borgbackup/ru?title=BorgBackup/ru
https://habr.com/ru/company/flant/blog/420055/
https://crontab.guru/every-5-minutes
