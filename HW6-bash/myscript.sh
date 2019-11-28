#!/bin/bash

function createMailBody {
  echo "Report statistics" > /tmp/mail.txt
}

function sendMail {
  mail -s "Report statistics" "vagrant" < /tmp/mail.txt
}

function top10UserIP {
  echo "Top 10 User IP" >> /tmp/mail.txt
  cat /tmp/tmpLog.log | awk '{print $1}' | sort | uniq -c | sort -nr | head >> /tmp/mail.txt
  echo "" >> /tmp/mail.txt
}

function top10Address {
  echo "Top 10 Address" >> /tmp/mail.txt
  cat /tmp/tmpLog.log | awk '{print $7}' | sort | uniq -c | sort -nr | head >> /tmp/mail.txt
  echo "" >> /tmp/mail.txt
}

function allErrors {
  echo "All errors list" >> /tmp/mail.txt
  cat /tmp/tmpLog.log | awk '($9 !~ /200|301/) && $6 ~ /GET|POST|HEAD/' | awk '{ print $1" "$4" "$5" "$6" "$7" "$8" "$9}' >> /tmp/mail.txt
  echo "" >> /tmp/mail.txt
}

function allReturnCodes {
  echo "All return codes list" >> /tmp/mail.txt
  cat /tmp/tmpLog.log | awk '{print $9}' | sort | uniq -c | sort -nr >> /tmp/mail.txt
  echo "" >> /tmp/mail.txt
}

function setValue {
  /usr/local/bin/etcdctl set $1 $2
}

function getValue {
  local __resultvar=$2
  
  local myresult=$(/usr/local/bin/etcdctl get $1 2>/dev/null)

  if [ -z $myresult ]; then
    eval $__resultvar=1
  else
    eval $__resultvar="'$myresult'"
  fi
}

##!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## Основное тело скрипта
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

#запрос указателя на чтение
getValue cLine currentLine

#echo "current line: $currentLine"

#создаем кусок файла для чтения (сто строк, начиная с указателя)
tail -n+$currentLine /vagrant/access-4560-644067.log | head -n100 > /tmp/tmpLog.log

#если файл пустой - выходим
FILESIZE=$(stat -c%s "/tmp/tmpLog.log")
if [ $FILESIZE = 0 ]
then
  echo "No data..."
  exit 0
fi

#формируем тело почтового сообщения
createMailBody

#подсчитываем ТОП10 IP адресов (с наибольшим кол-вом запросов) 
top10UserIP

#подсчитываем TOP10 запрашиваемых адресов (с наибольшим кол-вом запросов) 
top10Address

#записываем все ошибки c момента последнего запуска
allErrors

#записываем все коды возврата с указанием их кол-ва
allReturnCodes

#отправляем отчет на почту
sendMail

#фиксируем новый указатель
setValue cLine $(($currentLine+100))

echo "End..."
