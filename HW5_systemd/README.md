# Выполнено ДЗ №5

 - [x] Основное ДЗ
 - [] Задание со *

## В процессе сделано:

### Настройка сервиса мониторинга

Задача сервиса -  раз в 30 секунд мониторитþ лог на предмет наличия ключевого слова. Файл и слово задаваются в /etc/sysconfig.

Файл с конфигурацией размещен в /etc/sysconfig/watchlog. В данном файле задается путь к файлу с логом и слово для поиска.

В качестве лога используется /var/log/watchlog.log.

Скрипт поиска находится в /opt/watchlog.sh.

Unit файл описания сервиса размещен в /etc/systemd/system/watchlog.service.

Unit файл для таймера размещен в /etc/systemd/system/watchlog.service.  

В таймере определены переменные OnStartupSec - для первоначального запуска сервиса-поиска, и переменная OnUnitActiveSec, которая задает периодичность запуска.

Настройка производится при помощи playbook-а /otus-linux-2/HW5_systemd/provision/watchlog.yml, который запускается при старте vagrant-машины.

Проверка сервиса (после запуска машины подождать 1-2 минуты):

```bash
vagrant up
vagrant ssh -c "sudo tail -f /var/log/messages"
```

### Установка и запуск spawn-fcgi

Переменные сервиса определены в файле /etc/sysconfig/spawn-fcgi.

Сам сервис определен в файле /etc/systemd/system/spawn-fcgi.service.

Настройка производится при помощи playbook-а /otus-linux-2/HW5_systemd/provision/apache.yml, который запускается при старте vagrant-машины.

Проверка сервиса:

```bash
vagrant up
vagrant ssh -c "systemctl status spawn-fcgi"
```

### Установка и запуск apache httpd в режиме "instantiated" services (продолжение)

Для реализации режима "instantiated" services вместо unit-файла /usr/lib/systemd/system/httpd.service используется /usr/lib/systemd/system/httpd@.service (знак @ говорит systemd, что это шаблон).

В самом unit-файле возможность использвать различные настройки реализована при помощи:

```
EnvironmentFile=/etc/sysconfig/httpd-%I
```

I - передается в качестве параметра при запуске сервиса в виде:

```bash
$ systemctl start httpd@first
```

В данном случае - параметр будет равен "first".

Два вида окружения задаются в файлах /etc/sysconfig/httpd-first и /etc/sysconfig/httpd-second.

В них указаны имена файлов-конфигураций, соответственно - conf/first.conf и conf/second.conf.

Для демонстрационных целей разница в конфигурациях заключается в портах, которые будет слушать httpd: 8080 и 8090.

Настройка производится при помощи playbook-а /otus-linux-2/HW5_systemd/provision/apache.yml, который запускается при старте vagrant-машины.

Проверка сервиса:

```bash
vagrant up
vagrant ssh -c "sudo ss -tnulp | grep httpd"
```

## Обнаруженные проблемы

1. Опечатка в методичке
   
   Cтр. пять: вместо EnvironmentFile=/etc/sysconfig/watchdog должно быть EnvironmentFile=/etc/sysconfig/watchlog

2. Ошибка при запуске сервиса - не найден сервис
   
   ```bash
   [root@localhost ~]# systemctl start httpd@first
   Failed to start httpd@first.service: Unit not found.
   ```

   В имени unit-файла должен присутствовать символ @. Иначе сервис не распознается как шаблон (думаю, стоит указать в методичке).

3. Ошибка при запуске сервиса - нет прав на прослушивае порта
   
   Permission denied: AH00072: make_sock: could not bind to address 0.0.0.0:8090

   SELinux не позволяет использовать нестандартные порта для http.

   Исправляем это при помощи соответствующего правила, к примеру (в ДЗ используется модуль ansible):

   ```bash
   $ sudo semanage port -a -t http_port_t -p tcp 8090
   ```



