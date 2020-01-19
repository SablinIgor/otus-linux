# Выполнено ДЗ №14

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:

### Описание стенда

Хосты разворачиваются при помощи Vagrant-а.

Хост rsys - центральный сервер логирования. Хранит логи с хоста web, кроме логов nginx и аудита изменения конфигурации nginx.

(*) Хост elk - развернуты стек ELK, т.е. Logstash, ElasticSearch и Kibana. Кибана доступна по порту 5601.

Хост web - установлен Nginх. Веб-сервер доступен на порту 8889.

### Детали реализации

WEB

Установка nginx производится при помощи плейбука Ansible - provisioning/nginx.yml. Настройка filebeat делается при помощи inline-shell vagrant-а, в этом же скрипте происходит настройка правил auditd (что бы не спамилось лишее - добавлено правило auditctl -a exclude,always -F msgtype=SYSCALL) и указание rsyslog-у отсылать логи на хост rsys (файл /etc/rsyslog.conf).

Для отслеживание логов nginx-а и auditd в filebeat используются модули nginx и auditd, соответственно.

```bash
$ filebeat modules enable nginx
$ filebeat modules enable auditd
```

Настройки filebeat (в том числе указание удаленного сервера elk) находятся в файле /provisioning/filebeat.yml

ELK

Установка стека выполняется плейбуком Ansible provisioning/elk.yml.

Используются роли (настройки по-умолчанию):

- geerlingguy.java
- geerlingguy.elasticsearch
- geerlingguy.logstash
- geerlingguy.kibana

RSYS

Настройки выполняютя в файле /etc/rsyslog.conf.

Открытые порты

```
# Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

Шаблон принимаемых логов

```
$template remote-incoming-logs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log" 
*.* ?remote-incoming-logs
& stop
```

## Как проверить

### Центальный сервер rsyslog

```bash
$ vargant up
$ vagrant shh rsys
$ sudo ls -l /var/log/web
total 40
-rw-------. 1 root root    75 Jan 18 20:26 chronyd.log
-rw-------. 1 root root 17977 Jan 18 20:31 filebeat.log
-rw-------. 1 root root   308 Jan 18 20:31 rsyslogd.log
-rw-------. 1 root root    98 Jan 18 20:26 sshd.log
-rw-------. 1 root root     0 Jan 18 20:26 sudo.log
-rw-------. 1 root root   292 Jan 18 20:26 systemd.log
-rw-------. 1 root root    65 Jan 18 20:26 systemd-logind.log
```

В каталог /var/log/web сохраняются логи с хоста web

### ELK - логи Nginx и аудит конфигурации Nginx

```bash
$ vargant up
```

Далее несколько раз зайти на сайт - http://[VAGRANT_HOST]:8889.
После - войти в Кибану (http://[VAGRANT_HOST]:5601), в настройках Management->Index patterns настроить индекс - Create index pattern (к примеру, filebeat-*).
И посмотреть логи в Discover.

Скриншоты

- логи Nginx: https://pasteboard.co/IQycanS.png
- аудит nginx.conf: https://pasteboard.co/IQya8Cu.png

## Используемые источники

https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/
https://www.rsyslog.com/doc/v8-stable/configuration/templates.html
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html
https://pawelurbanek.com/elk-nginx-logs-setup
https://www.linuxquestions.org/questions/linux-security-4/auditd-syslog-help-needed-too-many-logs-870993/
https://1cloud.ru/help/security/audit-linux-c-pomoshju-auditd
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-module-auditd.html
https://logit.io/sources/configure/nginx#step1
