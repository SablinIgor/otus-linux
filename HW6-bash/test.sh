#!/bin/bash

function setValue {
  echo "SetKey function was colled wyth key $1 and value $2!"
  etcdctl set $1 $2
}

function getValue {
  echo "GetKey function was colled with key $1!"
  etcdctl get $1
}

#setValue testValue 2100
#getValue testValue

# FILESIZE=$(stat -c%s "tmp.log")

# +Реализовать защиту от повторного запуска
# +Получить указатель на строку файла
# +Прочитать кусок и лога во временный файл
# Провести анализ временного файла
# Сформировать и отправить текст письма
# +Записать в базу новый указатель

LOCK_FILE=script.lock
exec 99>"$LOCK_FILE"

flock -n 99
RC=$?
if [ "$RC" != 0 ]; then
    # Send message and exit
    echo "Already running script. Try again after sometime."
    exit 1
fi

echo "Start..."
sleep 20
echo "End..."

# Поиск всех ошибок
cat access-4560-644067.log | awk '($9 !~ /200|301/) && $6 ~ /GET|POST|HEAD/' | awk '{ print $1" "$4" "$5" "$6" "$7" "$8" "$9}'

