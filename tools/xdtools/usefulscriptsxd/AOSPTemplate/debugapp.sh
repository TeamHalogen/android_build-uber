#/bin/sh

## CONFIGURABLE VARS START

# App name (name of the module recommended, e.g. LatinIME)
APP_NAME=""
# Filename of the file pushed to your device
# Will be saved on /sdcard/$LOCL_FN
LOCL_FN="app.apk"
# Activity to start, only effective if $OPEN_ACTIVITY == 1
START_ACTIVITY=".MainActivity"
# Switch to enable/disable opening $START_ACTIVITY (1 open, 0 don't open)
OPEN_ACTIVITY=1
# Switch to enable/disable automatic logcat after installing the app
START_LOGCAT=1
# Tag of the app in the logcat (Tag is the string used in logcat to identify
# which app or component is writing to logcat, e.g. on D/Cornowser: .....,
# Cornowser is the tag name, so you specify 'Cornowser' for $APP_TAG)
APP_TAG="$APP_NAME"
# The path to the out apk. 
# e. g. out/target/product/oneplus2/system/app/LatinIME/LatinIME.apk
# $OUT is the current out path.
# This usually does not need to be modified
DBGAPKPATH="$OUT/system/app/$APP_NAME/$APP_NAME.apk"
# Arguments to pass when using ADB
ADBARGS=""
# Compile the app? Default is true, this usually does not need to be modified!
# Unless you know what you are doing...
COMPILEAPP=true
# Package name. Self-explanatory.
APPK="com.example.app"
# Build arguments (usually does not need to be modified)
BUILD_ARGS=""

## CONFIGURABLE VARS END

# DO NOT MODIFY THIS LINE!!!
CONTINUEXEC=true

if [ "$1" == "--adbArgs" ]; then
  ADBARGS="$2 $3 $4 $5 $6"
  COMPILEAPP=true
fi

if [ "$1" == "noclean" ]; then
  BUILD_ARGS="$BUILD_ARGS noclean"
  COMPILEAPP=true
fi

if [ -z "$1" ]; then source buildDebugApp.sh $BUILD_ARGS
elif [ COMPILEAPP ]; then source buildDebugApp.sh $BUILD_ARGS; fi

echo "Requesting root..."
adb root

if [ "$1" == "-l" ]; then
  adb logcat -v tag -s $APP_TAG:*
  CONTINUEXEC=false
elif [ "$1" == "--cleardata" ]; then
  adb shell pm clear $APPK
  CONTINUEXEC=false
elif [ "$1" == "-i" ]; then
  adb push $DBGAPKPATH /sdcard/$LOCL_FN
  adb shell pm set-install-location 1
  adb shell pm install -rdtf /sdcard/$LOCL_FN
  CONTINUEXEC=false
elif [ "$1" == "--start" ]; then
  if [ $OPEN_ACTIVITY = 1 ]; then
    adb shell am start -n $APPK/$START_ACTIVITY
  else echo "Opening activity not supported."
  fi
  CONTINUEXEC=false
elif [ "$1" == "--uninstall" ]; then
  adb shell pm uninstall $APPK
  CONTINUEXEC=false
elif [ "$1" == "--reinstall" ]; then
  adb shell pm uninstall $APPK
  adb push $DBGAPKPATH /sdcard/$LOCL_FN
  adb shell pm set-install-location 1
  adb shell pm install -rdtf /sdcard/$LOCL_FN
  CONTINUEXEC=false
fi

if [ CONTINUEXEC ]; then
  adb $ADBARGS push $DBGAPKPATH /sdcard/$LOCL_FN
  adb $ADBARGS root>/dev/null
  adb $ADBARGS wait-for-device
  adb $ADBARGS shell pm set-install-location 1
  adb $ADBARGS shell pm install -rdtf /sdcard/$LOCL_FN
  if [ OPEN_ACTIVITY == 1] ; then
    adb $ADBARGS shell am start -n $APPK/$START_ACTIVITY
  fi
  if [ START_LOGCAT  == 1 ]; then
    if [ "$1" == "--grp" ]; then adb $ADBARGS logcat -v tag -s $APP_TAG:* | grep $2
    else adb $ADBARGS logcat -v tag -s $APP_TAG:*
    fi
  fi
fi
