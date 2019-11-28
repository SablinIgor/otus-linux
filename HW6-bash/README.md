# Выполнено ДЗ №6

 - [x] Основное ДЗ
 - [x] Задание со * (трапы и функции, а также sed и find +1 балл)

## В процессе сделано:

### Подготовительные работы:
  - при запуске vagrant-машины устанавливается и запускается etcd. В нем будет хранится указатель на строку файла, с которой нужно считать информацию. Чтение будет произоводится блоками по 100 строк.

  ````
  curl -L https://github.com/etcd-io/etcd/releases/download/v3.3.11/etcd-v3.3.11-linux-amd64.tar.gz -o etcd-v3.3.11-linux-amd64.tar.gz
  tar xzvf etcd-v3.3.11-linux-amd64.tar.gz
  mv /tmp/etcd-v3.3.11-linux-amd64/* /opt/etcd/
  ln -s /opt/etcd/etcdctl /usr/local/bin/etcdctl
  cd /opt/etcd
  ./etcd &
  ````

  - дополнительно ставится пакет mailx для отправки пользователю (vagrant)

  - заводится задача для cron-а, которая раз в две минуты будет запускать скрипт анализа логов

### Основные работы

  - команда для чтения файлов:

    ````
    tail -n+$currentLine /vagrant/access-4560-644067.log | head -n100 > /tmp/tmpLog.log
    ````

  - защита от повторного запуска: есть несколько вариантов - самому создавать и удалять лок-файл (минусы - не защищает от прерываний), делать тоже самое, но добавлять trap-ы для перехвата прерываний, и тот, который выбрал я, - использовать flock. 

    ````
    LOCK_FILE=script.lock
    exec 99>"$LOCK_FILE"

    flock -n 99
    RC=$?
    if [ "$RC" != 0 ]; then
        # Send message and exit
        echo "Already running script. Try again after sometime."
        exit 1
    fi
    ````

  - поиск ТОП 10 IP

    ````
    cat /tmp/tmpLog.log | awk '{print $1}' | sort | uniq -c | sort -nr | head
    ````

  - поиск ТОП 10 запросов

    ````
    cat /tmp/tmpLog.log | awk '{print $7}' | sort | uniq -c | sort -nr | head
    ````

  - поиск всех кодов ошибок

    ````
    cat /tmp/tmpLog.log | awk '($9 !~ /200|301/) && $6 ~ /GET|POST|HEAD/' | awk '{ print $1" "$4" "$5" "$6" "$7" "$8" "$9}'
    ````

  - поиск всех кодов ответа

    ````
    cat /tmp/tmpLog.log | awk '{print $9}' | sort | uniq -c | sort -nr
    ````

  - задачка для cron-а (/dev/null использую, чтобы cron не спамил своими письмами)

    ````
    (crontab -l 2>/dev/null; echo \"*/2 * * * * /vagrant/myscript.sh > /dev/null\") | crontab -
    ````

## Как проверить работоспособность:
  - vagrant up (подождать семь минут)
  - vagrant ssh
  - mail (увидеть несколько писем с требуемой информацией)

## Проблемы во время работы
  
  - не забывать, что операция приравнивания не любит пробелы

