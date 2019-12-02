#!/bin/bash

set -e
#set -x

pid=""
tty=""

for filename in `ls -v /proc/`; do
 pid=$(echo $filename | cut -d"/" -f3)

 if [ ! -e /proc/$pid/status ]; then
   continue
 fi

 if [ -n "$pid" ] && [ "$pid" -eq "$pid" ] 2>/dev/null; then
  if [ -e "/proc/$pid/fd/0" ]; then
    tty=$(readlink -f /proc/$pid/fd/0 | cut -d"/" -f'3 4')
    if [ "$tty" = "null" ] ; then tty="?"; fi
  else
    tty="?"
  fi 

  isLock=$(grep -w "VmLck:" /proc/$pid/status | awk -F "( *)" '{print $2}')
  
  if [[ $isLock > 0 ]]; then 
    isLock="L" 
  else
    isLock="" 
  fi

  isThreads=$(grep -w "Threads:" /proc/$pid/status | awk -F " " '{print $2}')

  if [[ $isThreads > 1 ]]; then
    isThreads="l"
  else
    isThreads=""
  fi

  isLeader=$(cat /proc/$pid/stat | awk '{print $(NF-46)}')

  if [[ $isLeader -eq $pid ]]; then
    isLeader="s"
  else
    isLeader=""
  fi

  isForegraund=$(cat /proc/$pid/stat | awk '{print $(NF-44)}')

  if [[ $isForegraund -gt 0 ]]; then
    isForegraund="+"
  else
    isForegraund=""
  fi

  cmd=$(cat /proc/$pid/cmdline | xargs -0 echo)

  if [[ ! -n "$cmd" ]]; then
    cmd=$(grep -w "Name:" /proc/$pid/status | awk -F " " '{print "["$2"]"}')
  fi

  time=$(cat /proc/$pid/stat | awk '{print ($(NF-38)/100 + $(NF-37)/100)}')

  time="$(awk -v a="$time" 'BEGIN { printf "%d\n", (a/60) }'):$(awk -v a="$time" 'BEGIN { printf "%d\n", (a%60) }')"

  stat="$(cat /proc/$pid/stat | awk '{print $(NF-49)}')$(cat /proc/$pid/stat | awk '{if($(NF-33) < 0) {print "<";} else if($(NF-33) > 0) print "N"}')$isLock$isLeader$isThreads$isForegraund"

  printf "%6s\t%s\t%s\t%s\t%s\n" $pid "$tty" $stat $time "$cmd"
 fi
done
