#!/bin/bash

TEMPLATE_PATH="$XD_AOSP_TEMPLATE_PATH"
if [ -z "$XD_AOSP_TEMPLATE_PATH" ]; then TEMPLATE_PATH="../AOSPTemplate"; fi
CURRENT_DIR_NAME="${PWD##*/}"
APP_PATH="$(pwd)"
EDIT_SCRIPT_FILES="false"

if [ "$1" == "--undo" ]; then
  cd $TEMPLATE_PATH
  ALLFILES=$(find .)
  cd $APP_PATH
  rm -rf app
  for word in $ALLFILES; do
    if [ ! $word == "." ]; then
      rm -rf $word
    fi
  done
  EDIT_SCRIPT_FILES="false"
elif [ "$1" == "--cp-scripts" ]; then
  cp $TEMPLATE_PATH/configure.sh ./
  cp $TEMPLATE_PATH/debugapp.sh ./
  cp $TEMPLATE_PATH/buildDebugApp.sh ./
  EDIT_SCRIPT_FILES="true"
elif [ "$1" == "--add-gitignore" ]; then
  cp $TEMPLATE_PATH/gitignore-file ./.gitignore
  [ -f "$APP_PATH/gitignore-file" ] && rm $APP_PATH/gitignore-file
  EDIT_SCRIPT_FILES="false"
else
  RESULT_OF_CP=0
  if [ -e "src/" ]; then
    cp -R $TEMPLATE_PATH/* ./
    cp $TEMPLATE_PATH/gitignore-file ./.gitignore
    mkdir -p $APP_PATH/app/src/main/
    ln -s $APP_PATH/src app/src/main/java
    ln -s $APP_PATH/res app/src/main/res
    ln -s $APP_PATH/AndroidManifest.xml app/src/main/AndroidManifest.xml
    rm $APP_PATH/README.md
    rm $APP_PATH/gitignore-file
  else
    echo "Not a compatible project. Please make sure that you have a src folder"
    RESULT_OF_CP=1
  fi
  if [ $RESULT_OF_CP == 0 ]; then EDIT_SCRIPT_FILES="true";
  else EDIT_SCRIPT_FILES="false"; fi
fi

if [ $EDIT_SCRIPT_FILES == "true" ]; then
  nano $APP_PATH/configure.sh
  nano $APP_PATH/debugapp.sh
  nano $APP_PATH/buildDebugApp.sh
fi
