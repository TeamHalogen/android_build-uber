#!/bin/bash

# CONFIGURABLE VARS START
# App name (can be anything you want) e. g. Settings App
APP_NAME=""
# CONFIGURABLE VARS END

# In this script you can add stuff that should be done before the build starts

function welcome() {
  echo "This is the configuration script to start building $APP_NAME."
}

function goodbye() {
  echo "Congratz! Seems that the configuration process was successful."
}


welcome
echo -en "\n"

## Add stuff here if necessary. Usually this is not changed.

goodbye


echo -en "\n"
