#!/bin/bash
BORG_SERVER="borg@server"
NAMEOFBACKUP="ETC"
DIRS="/etc"
REPOSITORY="${BORG_SERVER}:MyBorgRepo"

borg create --list -v --stats \
  $REPOSITORY::"files-{now:%Y-%m-%d_%H:%M:%S}" \
  $(echo $DIRS | tr ',' ' ') || \
   echo "borg create failed"
