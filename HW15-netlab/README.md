# Выполнено ДЗ №15

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:

### Описание стенда

Схема сети: https://clck.ru/M4Gfj

**Описание сети**

| Host          | Network                                                 | IP                                                         | Назначение                  |
|---------------|---------------------------------------------------------|------------------------------------------------------------|-----------------------------|
| inetRouter    | router-net<br>inet                                      | 192.168.255.1<br>10.0.2.15                                 | Роутер в интернет           |
| centralRouter | router-net<br>central-net<br>office1-net<br>office2-net | 192.168.255.2<br>192.168.0.1<br>192.168.1.1<br>192.168.2.1 | Центральный роутер          |
| office1Router | office1-net                                             | 192.168.1.254                                              | Роутер первого офиса        |
| office2Router | office2-net                                             | 192.168.2.254                                              | Роутер второго офиса        |
| centralServer | central-net                                             | 192.168.0.2                                                | Сервер в центральной сети   |
| office1Server | office1-net                                             | 192.168.1.10                                               | Сервер в сети первого офиса |
| office2Server | office2-net                                             | 192.168.2.10                                               | Сервер в сети второго офиса |

**router-net**

Netmask:   255.255.255.252<br>
Network:   192.168.255.0/30<br>
Broadcast: 192.168.255.3<br>
HostMin:   192.168.255.1<br>
HostMax:   192.168.255.2 <br>
Hosts/Net: 2 <br>

**central-net**

Netmask:   255.255.255.0<br>
Network:   192.168.0.0/24<br>
Broadcast: 192.168.0.255<br>
HostMin:   192.168.0.1<br>
HostMax:   192.168.0.254<br>
Hosts/Net: 254<br>

**office1-net**

Netmask:   255.255.255.0<br>
Network:   192.168.1.0/24<br>
Broadcast: 192.168.1.255<br>
HostMin:   192.168.1.1<br>
HostMax:   192.168.1.254<br>
Hosts/Net: 254<br>

**office2-net**

Netmask:   255.255.255.0<br>
Network:   192.168.2.0/24<br>
Broadcast: 192.168.2.255<br>
HostMin:   192.168.2.1<br>
HostMax:   192.168.2.254<br>
Hosts/Net: 254<br>

## Детали реализации

## Как проверить

Запустить vagrant и посмотреть при помощи команды traceroute как запрос на серверах последовательно проходит через роутеры.

```bash
$ vagrant up

$ vagrant ssh centralServer -c "traceroute ya.ru"
traceroute to ya.ru (87.250.250.242), 30 hops max, 60 byte packets
 1  gateway (192.168.0.1)  1.605 ms  1.103 ms  0.602 ms
 2  192.168.255.1 (192.168.255.1)  2.918 ms  2.429 ms  2.687 ms
 3  * * *
 4  * * *
 5  * * *
 6  ams-ix-am1.yandex.net (80.249.211.200)  14.429 ms  14.106 ms  13.616 ms
 7  ya.ru (87.250.250.242)  44.993 ms  40.464 ms  45.584 ms
Connection to 127.0.0.1 closed.

$ vagrant ssh office1Server -c "traceroute ya.ru"
traceroute to ya.ru (87.250.250.242), 30 hops max, 60 byte packets
 1  gateway (192.168.1.254)  1.259 ms  1.805 ms  1.299 ms
 2  192.168.1.1 (192.168.1.1)  2.454 ms  2.293 ms  1.715 ms
 3  192.168.255.1 (192.168.255.1)  10.409 ms  8.530 ms  8.026 ms
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  ya.ru (87.250.250.242)  42.395 ms  46.238 ms  45.782 ms
Connection to 127.0.0.1 closed.

$ vagrant ssh office2Server -c "traceroute ya.ru"
traceroute to ya.ru (87.250.250.242), 30 hops max, 60 byte packets
 1  gateway (192.168.2.254)  0.953 ms  1.081 ms  0.610 ms
 2  192.168.2.1 (192.168.2.1)  1.776 ms  3.767 ms  3.286 ms
 3  192.168.255.1 (192.168.255.1)  3.609 ms  14.821 ms  15.677 ms
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  ya.ru (87.250.250.242)  45.156 ms  45.377 ms  48.238 ms
Connection to 127.0.0.1 closed.

```

## Используемые ресурсы

https://www.draw.io/
http://jodies.de/ipcalc
https://linuxhint.com/centos7_router/
https://upcloud.com/community/tutorials/configure-iptables-centos/

