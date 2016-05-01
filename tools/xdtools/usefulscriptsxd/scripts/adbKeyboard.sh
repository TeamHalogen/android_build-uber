#!/bin/bash

OUTP=""
OUTI=0

while true
do
  read -n 1 char
  echo -en "\033[K\r"
  case $char in
  " " ) OUTP='%s';;
  "^?") OUTI=67;;
     *) OUTP=$char;;
  esac
  if [ ! OUTI = 0 ]; then adb shell input text "$OUTP" &>/dev/null
  else adb shell input event $OUTI; fi
  OUTP=""
  OUTI=0
  echo -en "\033[K\r"
done

