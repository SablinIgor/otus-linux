# Выполнено ДЗ №6

 - [x] Основное ДЗ
 - [x] Задание со * (трапы и функции, а также sed и find +1 балл)

## В процессе сделано:

### Подготовительные работы:
  - при запуске vagrant-машины устанавливается и запускается etcd

  ````
  curl -L https://github.com/etcd-io/etcd/releases/download/v3.3.11/etcd-v3.3.11-linux-amd64.tar.gz -o etcd-v3.3.11-linux-amd64.tar.gz
  tar xzvf etcd-v3.3.11-linux-amd64.tar.gz
  mv /tmp/etcd-v3.3.11-linux-amd64/* /opt/etcd/
  ln -s /opt/etcd/etcdctl /usr/local/bin/etcdctl
  cd /opt/etcd
  ./etcd &
  ````

### Заметки

  - чтение из файла кусками по 100 строк, начиная с N-ной строки

    tail -n+N test.in | head -n100

## Как проверить работоспособность:
  - vagrant up
  - vagrant ssh

## Проблемы во время работы

## Используемые источники
  - https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/
