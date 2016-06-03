#!/bin/bash

#
# Copyright (C) 2016 halogenOS (XOS)
#
#
# This script was originally made by xdevs23 (http://github.com/xdevs23)
# 

DEBUG_ENABLED=0

function logd() {
    [ $DEBUG_ENABLED == 1 ] && echo "$@"
}

[[ "$@" == *"debug"* ]] && DEBUG_ENABLED=1 || DEBUG_ENABLED=0

logd "Script start"

logd "Defining arg vars"
TOOL_ARG="$1"
TOOL_SUBARG="$2"
TOOL_THIRDARG="$3"

logd "Checking cpu count"

CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
THREAD_COUNT_BUILD=$(($CPU_COUNT * 4))
THREAD_COUNT_N_BUILD=$(($CPU_COUNT * 2))

logd "Saving current dir"
BEGINNING_DIR="$(pwd)"


logd "Checking if script is sourced"
if [ "$0" == "bash" ]; then echo -en "\n"
else
    echo "The script must be sourced!"
    return 990
fi

logd "Checking for envsetup"

if [ "$(declare -f breakfast > /dev/null; echo $?)" == 1 ]; then
    if [ -f "envsetup.sh" ]; then cd ..;  source build/envsetup.sh
    elif [ -f "build/envsetup.sh" ]; then source build/envsetup.sh
    else
        echo "envsetup.sh not found. CD to the root of the source tree first."
        return 860
    fi
    cd $BEGINNING_DIR
fi

logd "Sourcing help file"
source $(gettop)/build/tools/xdtoolshelp.sh

function lunchauto() {
    logd "Lunching..."
    BUILD_TARGET_DEVICE=""
    if [ ! -z $TOOL_THIRDARG ]; then BUILD_TARGET_DEVICE="$TOOL_THIRDARG";
    else                             BUILD_TARGET_DEVICE=""
    fi
    lunch $BUILD_TARGET_DEVICE
}

logd "Checking arguments"

case "$TOOL_ARG" in

    build)
        logd "Build!"
        
        if [ -z "$TOOL_SUBARG" ]; then
            xdtools_help_build
            return 0
        fi
        
        case "$TOOL_SUBARG" in
            
            full)
                if [ -z "$3" ] || [ ! -z "$TARGET_DEVICE" ]; then
                    xdtools_build_no_target_device
                else
                    logd "Starting build..."
                    lunchauto
                    echo "Using $THREAD_COUNT_BUILD threads for build."
                    make -j$THREAD_COUNT_BUILD bacon
                fi
            ;;
            *)      echo "Unknown build command \"$TOOL_SUBARG\"."    ;;
        
        esac
        
    ;;
    
    buildapp)
        lunchauto
        if [ -z "$TOOL_SUBARG" ]; then echo "No module name specified.";
        else make -j4 clean; make -j$THREAD_COUNT_BUILD $TOOL_SUBARG
        fi
    ;;
    
    reposync)
        REPO_ARG="$2"
        THREADS_REPO=$THREAD_COUNT_N_BUILD
        if [ -z "$2" ]; then REPO_ARG="auto"; fi
        case $REPO_ARG in
            turbo)      THREADS_REPO=1000       ;;
            faster)     THREADS_REPO=200        ;;
            fast)       THREADS_REPO=64         ;;
            auto)                               ;;
            slow)       THREADS_REPO=6          ;;
            slower)     THREADS_REPO=2          ;;
            single)     THREADS_REPO=1          ;;
            easteregg)  THREADS_REPO=384        ;;
            -h | --help | h | help | man )
                echo "Usage: reposync <speed>"
                echo "Available speeds are:"
                echo -en "  turbo\n  faster\n  fast\n  auto\n  slow\n"
                echo -en "  slower\n  single\n  easteregg\n\n"
                return 0
            ;;
            *) echo "Unknown argument \"$REPO_ARG\" for reposync ." ;;
        esac
        echo "Using $THREADS_REPO threads for sync."
        repo sync -j$THREADS_REPO --force-sync
    ;;

    reposynclow)
        REPO_ARG="$2"
        THREADS_REPO=$THREAD_COUNT_N_BUILD
        if [ -z "$2" ]; then REPO_ARG="auto"; fi
        case $REPO_ARG in
            turbo)      THREADS_REPO=1000       ;;
            faster)     THREADS_REPO=200        ;;
            fast)       THREADS_REPO=64         ;;
            auto)                               ;;
            slow)       THREADS_REPO=6          ;;
            slower)     THREADS_REPO=2          ;;
            single)     THREADS_REPO=1          ;;
            easteregg)  THREADS_REPO=384        ;;
            -h | --help | h | help | man )
                echo "Syncs without cloning old branches and tags"
                echo "(Fetches only that latest avaliable)"
                echo "So you save on the extra bandwidth you've got!"
                echo "Usage: reposynclow <speed>"
                echo "Available speeds are:"
                echo -en "  turbo\n  faster\n  fast\n  auto\n  slow\n"
                echo -en "  slower\n  single\n  easteregg\n\n"
                return 0
            ;;
            *) echo "Unknown argument \"$REPO_ARG\" for reposynclow ." ;;
        esac
        echo "Using $THREADS_REPO threads for sync."
        repo sync -j$THREADS_REPO --force-sync -c -f --no-clone-bundle --no-tags
    ;;
    
    debug)
        echo "Why should you be using debug as only argument? :D"
    ;;
    
    
    
    "")     echo "No argument specified."                           ;;
    *)      echo "Unknown argument \"$TOOL_ARG\"."                  ;;
    
esac

logd "Cd back to beginning dir"

cd $BEGINNING_DIR

logd "Exiting script"

return 0
