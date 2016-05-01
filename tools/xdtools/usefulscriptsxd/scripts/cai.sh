#!/bin/bash

## Change android ID

echo "Using root..."
adb root

CAID=$(adb shell content query --uri content://settings/secure --where "name=\'android_id\'")

echo -en "\nCurrent android id: $CAID\n"
if [ "$1" != "--show" ]; then
  echo "Changing android id to $1"

  adb shell content delete --uri content://settings/secure --where "name=\'android_id\'"
  adb shell content insert --uri content://settings/secure --bind name:s:android_id --bind value:s:$1

  echo "Getting current android id..."
  adb shell content query --uri content://settings/secure --where "name=\'android_id\'"

  echo "Done!"
fi

