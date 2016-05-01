#!/bin/bash

echo "Capturing screen..."
adb shell screencap -p /sdcard/screenshot.png
echo "Pulling screenshot..."
adb pull /sdcard/screenshot.png $1
echo "Done"
