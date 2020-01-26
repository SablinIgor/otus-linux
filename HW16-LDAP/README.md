# Выполнено ДЗ №16

 - [x] Основное ДЗ
 - [x] Задание со **

## В процессе сделано:

### Настройка IPA-сервера

Прежде всего насттроим правила firewalld

```bash
$ firewall-cmd --permanent --add-port=53/{tcp,udp} --add-port=80/tcp --add-port=88/{tcp,udp} --add-port=123/udp --add-port=389/tcp --add-port=443/tcp --add-port=464/{tcp,udp} --add-port=636/tcp

$ firewall-cmd --reload
```

Подправим файл /etc/hosts - удалим связь локалхоста с доменным именем хоста.

```bash
[root@ipa-server ~]# cat /etc/hosts
127.0.0.1 localhost.localdomain localhost
127.0.0.1 localhost4.localdomain4 localhost4
```

Если бы мы этого не сделали - получили бы ошибку:

```
The IPA Server hostname must not resolve to localhost. A routable IP address must be used.
```

Далее установим необходимые пакеты (dns не ставим, он и так есть в сети, и доменное имя сервера там уже прописано).

```bash
yum install ipa-server -y
```

Запускаем инсталлятор

```bash
ipa-server-install
```

На вопрос хотим ли мы сконфигурировать DNS - отвечаем нет. Он и так у нас есть.

В процессе настройки указываем пароли к служебным учетным записям.

Далее веб-консоль администратора будет доступна по адресу https://ipa-server.devlab.local

### Настройка IPA-клиента

Настройку клиента осуществляем при помощи playbook-а Ansible - ipa-client.yml.

Для экономии на сборе фактов, указываем в инвентори полное доменное имя хоста и используем соответствующую переменную в плейбуке - inventory_hostname

```bash
[admin@sandbox infra]$ cat inventory 

...

[ipaclient]
ipatest.devlab.local ansible_host=10.21.21.32
```

### Создание учетной записи

На IPA-сервере авторизируемся:

```bash
kinit admin
```

И создаем пользователя:

```bash
ipa user-add isablin --first=Игорь --last=Саблин --password
```

Здесь - isablin - это логин пользователя, first и last - соответвенно имя и фамилия.

... после ввода команды система запросит пароль для создаваемого пользователя.

Далее мы можем пройти в консоль администратора и, к примеру, исправить оболочку со стандартного /bin/sh на более привычный /bin/bash.

## Пример настройки клиента

Запускаем плейбук и пытаемся зайти под созданным ранее в IPA клиентом...

```bash
[admin@sandbox infra]$ ansible-playbook ipa-client.yml -l ipaclient -u root --key-file ~/.ssh/devlab

PLAY [all] ******************************************************************************

TASK [Install package] *****************************************************************************************
ok: [10.21.21.32]

TASK [Setup IPA client] *****************************************************************************************
changed: [10.21.21.32]

PLAY RECAP ******************************************************************************
10.21.21.32                : ok=2    changed=1    unreachable=0    failed=0   

[admin@sandbox infra]$ ssh isablin@10.21.21.32
Warning: Permanently added '10.21.21.32' (ECDSA) to the list of known hosts.
Password: 
Creating home directory for isablin.
[isablin@ipatest ~]$ 
```

## Используемые ресурсы 

https://docs.fedoraproject.org/en-US/Fedora/15/html/FreeIPA_Guide/installing-ipa.html
https://www.dmosk.ru/miniinstruktions.php?mini=freeipa-centos

