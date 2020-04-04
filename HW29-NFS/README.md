# Выполнено ДЗ №29

 - [x] Основное ДЗ
 - [] Задание со *

## В процессе сделано:

Настроен сервер NFS предоставляющий доступ к каталогу /var/nfs в режиме только для чтения.

В каталоге /var/nfs есть подкаталог upload открытый для записи.

Так же поднимается клиентский хост, при загрузке монтирующий nfs каталог /var/nfs в локальный каталог /mnt/nfs-share. Монтирование идет по протоколу NFS v.3. Используется опция nofail для предотвращения остановки загрузки хоста, если NFS-сервер недоступен.

### Описание стенда

Стенд поднимается при помощи команды 

```
vargant up
```

Посмотреть смонтированные каталоги на клиенте можно при помощи команды
```
vagrant ssh client
mount | grep nfs
```

Попытка записи в корень каталога приведет к ошибке
```
touch /mnt/nfs-share/test
touch: cannot touch ‘/mnt/nfs-share/test’: Permission denied
```

В каталог /mnt/nfs-share/upload запись дозволяется
```
[vagrant@client ~]$ touch /mnt/nfs-share/upload/test
```

### Дополнительные источники

https://wiki.it-kb.ru/unix-linux/centos/linux-how-to-setup-nfs-server-with-share-and-nfs-client-in-centos-7-2
https://xakep.ru/2017/02/15/firewalld/
