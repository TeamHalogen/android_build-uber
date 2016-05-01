#!/bin/bash

# CONFIGURABLE VARS START

# Device to lunch automatically, leave blank to ask.
LUNCH_DEVICE=""
# Module name, e. g. LatinIME
MODULE_NAME=""

# CONFIGURABLE VARS END

echo "Configuring..."
source configure.sh $1

echo "Starting build..."
CRTDIR=$(pwd)
croot
lunch $LUNCH_DEVICE
if [ "$1" != "noclean" ]; then make -j4 clean; fi
make -j32 $MODULE_NAME
cd $CRTDIR

echo "Build finished"
