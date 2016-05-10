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

TOOL_ARG=""
TOOL_SUBARG=""
TOOL_THIRDARG=""
TOOL_4ARG=""
TOOL_5ARG=""
function vardefine() {
    TOOL_ARG=""
    TOOL_SUBARG=""
    TOOL_THIRDARG=""
    TOOL_4ARG=""
    TOOL_5ARG=""
    BUILD_TARGET_DEVICE=""
    BUILD_TARGET_MODULE=""
    [[ "$@" == *"debug"* ]] && DEBUG_ENABLED=1 || DEBUG_ENABLED=0
    TOOL_ARG="$0"
    TOOL_SUBARG="$1"
    TOOL_THIRDARG="$2"
    TOOL_4ARG="$3"
    TOOL_5ARG="$4"
    logd "TOOL_ARG=$TOOL_ARG"
    logd "TOOL_SUBARG=$TOOL_SUBARG"
    logd "TOOL_THIRDARG=$TOOL_THIRDARG"
}
vardefine

if [ "$1" == "envsetup" ]; then
    TOOL_ARG="$1"
    TOOL_SUBARG="$2"
    TOOL_THIRDARG="$3"
    TOOL_4ARG="$4"
    TOOL_5ARG="$5"
    echo -en "\n"
fi

logd "Checking cpu count"

CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
THREAD_COUNT_BUILD=$(($CPU_COUNT * 4))
THREAD_COUNT_N_BUILD=$(($CPU_COUNT * 2))

logd "Saving current dir"
BEGINNING_DIR="$(pwd)"

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
source $(gettop)/build/tools/xdtools/xdtoolshelp.sh

function echoe() {
    echo -e "$@"
}

function echob() {
    echo -e "\033[1m$@\033[0m"
}

function lunchauto() {
    BUILD_TARGET_DEVICE=""
    if [ ! -z "$TOOL_THIRDARG" ]; then BUILD_TARGET_DEVICE="$TOOL_THIRDARG";
    else                               BUILD_TARGET_DEVICE=""
    fi
    echoe "Eating breakfast..."
    breakfast $BUILD_TARGET_DEVICE
    echoe "Lunching..."
    lunch $BUILD_TARGET_DEVICE
}

logd "Checking arguments"

function build() {
    vardefine $@
    logd "Build!"
    
    if [ -z "$TOOL_SUBARG" ]; then
        xdtools_help_build
        return 0
    fi
    
    if [ -z "$TOOL_THIRDARG" ] || [ ! -z "$TARGET_DEVICE" ]; then
        xdtools_build_no_target_device
    else
        case "$TOOL_SUBARG" in
            
            full | module | mm)
                echob "Starting build..."
                BUILD_TARGET_MODULE="bacon"
                lunchauto
                ( [ "$TOOL_5ARG" == "noclean" ] || [ "$TOOL_4ARG" == "noclean" ] ) \
                    || make -j4 clean
                [ "$TOOL_SUBARG" == "module" ] && BUILD_TARGET_MODULE="$TOOL_4ARG"
                [ "$TOOL_SUBARG" == "mm" ]     && BUILD_TARGET_MODULE="$TOOL_4ARG"
                echo "Using $THREAD_COUNT_BUILD threads for build."
                [ "$TOOL_SUBARG" != "mm" ] && \
                    make -j$THREAD_COUNT_BUILD $BUILD_TARGET_MODULE \
                    || \
                    mmma -j$THREAD_COUNT_BUILD $BUILD_TARGET_MODULE
            ;;
            
            nothing)
                echob "Starting build..."
                BUILD_TARGET_MODULE="bacon"
                echoe "Note: You have specified to build \033[4mnothing\033[0m."
                echo -n "Skip clean: " && \
                    ( [ "$TOOL_5ARG" == "noclean" ] || [ "$TOOL_4ARG" == "noclean" ] ) \
                    && echo "yes" || echo "no"
                [ "$TOOL_THIRDARG" == "module" ] && BUILD_TARGET_MODULE="$TOOL_4ARG"
                [ "$TOOL_THIRDARG" == "mm" ]     && BUILD_TARGET_MODULE="$TOOL_4ARG"
                echo "BUILD_TARGET_MODULE=$BUILD_TARGET_MODULE"
                echo "You are doing a '$TOOL_THIRDARG' build."
                echo "Using $THREAD_COUNT_BUILD threads for build."
                echoe "\nBuild command: "
                [ "$TOOL_SUBARG" != "mm" ] && \
                    echo -n "make -j$THREAD_COUNT_BUILD $BUILD_TARGET_MODULE" \
                    || \
                    echo -n "mmma -j$THREAD_COUNT_BUILD $BUILD_TARGET_MODULE"
                echo -en "\n"
            ;;
            *)      echo "Unknown build command \"$TOOL_SUBARG\"."    ;;
        
        esac
    fi
}

function buildapp() {
    vardefine $@
    echo "Building \"$TOOL_SUBARG\"..."
    lunchauto
    if [ -z "$TOOL_SUBARG" ]; then echo "No module name specified.";
    else make -j4 clean; make -j$THREAD_COUNT_BUILD $TOOL_SUBARG
    fi
}

function reposync() {
    if [ "$1" == "low" ]; then
        TOOL_ARG="reposynclow"
        TOOL_SUBARG="$2"
        TOOL_THIRDARG="$3"
    else vardefine $@
    fi
    REPO_ARG="$TOOL_SUBARG"
    THREADS_REPO=$THREAD_COUNT_N_BUILD
    if [ -z "$TOOL_SUBARG" ]; then REPO_ARG="auto"; fi
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
            if [ $TOOL_ARG == "reposynclow" ]; then
                echo "Syncs without cloning old branches and tags"
                echo "(Fetches only that latest avaliable)"
                echo "So you save on the extra bandwidth you've got!"
            fi
            echo "Usage: $TOOL_ARG <speed>"
            echo "Available speeds are:"
            echo -en "  turbo\n  faster\n  fast\n  auto\n  slow\n"
            echo -en "  slower\n  single\n  easteregg\n\n"
            return 0
        ;;
        *) echo "Unknown argument \"$REPO_ARG\" for reposync ." ;;
    esac
    echo "Using $THREADS_REPO threads for sync."
    [ $TOOL_ARG == "reposynclow" ] && echo "Saving bandwidth for free!"
    repo sync -j$THREADS_REPO  --force-sync $([ "$TOOL_ARG" == "reposynclow" ] \
        && echo -en "-c -f --no-clone-bundle --no-tags" || echo -en "") $TOOL_THIRDARG
}

function reposynclow() {
    reposync low $@
}

function reporesync() {
    vardefine $@
    echoe "Preparing..."
    FRSTDIR="$(pwd)"
    cd $(gettop)
    case "$TOOL_SUBARG" in
    
        full | full-x | "full-local")
            echoe "Collecting directories..."
            ALLFD=$(echo -en $(ls -a))
            echoe "Removing directories..."
            echo -en "\n\r"
            for ff in $ALLFD; do
                case "$ff" in
                    "." | ".." | ".repo");;
                    *)
                        echo -en "\rRemoving $ff\033[K"
                        rm -rf "$ff"
                    ;;
                esac
            done
            echo -en "\n"
            if [ "$TOOL_SUBARG" == "full-x" ]; then
                echoe "Removing repo projects..."
                rm -rf .repo/projects/*
                echoe "Removing repo objects..."
                rm -rf .repo/project-objects/*
            fi
            echoe "Starting sync..."
            if [ "$TOOL_SUBARG" == "full-local" ]; then
                repo sync -j$THREAD_COUNT_N_BUILD --local-only --force-sync
            else [[ "$@" == *"low"* ]] && reposynclow || reposync fast
            fi
        ;;

        
        repo | repo-x | "repo-local")
            [ -z "$TOOL_THIRDARG" ] && xdtools_help_reporesync && return 0
            [ "$TOOL_SUBARG" == "repo-x" ] && [ -z "$TOOL_4ARG" ] && \
                xdtools_help_reporesync && return 0
            rm -rf $TOOL_THIRDARG
            if [ "$TOOL_SUBARG" == "repo-x" ]; then
                rm -rf .repo/project-objects/$TOOL_4ARG.git
                rm -rf .repo/projects/$TOOL_THIRDARG.git
            fi
            if [ "$TOOL_SUBARG" == "repo-local" ]; then
                repo sync $TOOL_THIRDARG -j$THREAD_COUNT_N_BUILD \
                    --local-only --force-sync --force-broken
            else [[ "$@" == *"low"* ]] && reposynclow auto $TOOL_THIRDARG || \
                reposync auto $TOOL_THIRDARG
            fi
        ;;
        
        "" | help | *)
            xdtools_help_reporesync
            cd $FRSTDIR
            return 0
        ;;
    
    esac
    cd $FRSTDIR
}

function repair-repo() {
    vardefine $@
    echo -e "\033[1mPrepairing to repair repo...\033[0m"
    FRSTDIR=$(pwd)
    cd $(gettop)
    
    if [ -e ".repo/repo" ]; then
        cd .repo/repo
        REPO_URL=$(echo -en $(git remote -v | cut -d ' ' -f 1 | awk 'BEGIN {FS="\t"} {print $2}') | cut -d ' ' -f 1)
    fi
    
    [[ "$REPO_URL" != *"git"* ]] && REPO_URL="https://github.com/halogenOS/git-repo.git"
    [ ! -z "$TOOL_SUBARG" ] && REPO_URL="$TOOL_SUBARG"
    
    echo "  Found $REPO_URL as remote"
    
    cd $(gettop)/.repo
    
    echo -e "\033[1mDownloading repo...\033[0m"
    [ -e "repo" ] && rm -rf repo
    git clone $REPO_URL repo
    
    echo -e "\033[1mRepair complete!\033[0m"
    
    cd $FRSTDIR
}

function mkgradleproject() {
    echoe "\033[1mStarting script for making gradle project...\033[0m"
    USFF="$(gettop)/build/tools/xdtools/usefulscriptsxd"
    export XD_AOSP_TEMPLATE_PATH="$USFF/AOSPTemplate"
    bash $USFF/scripts/makegradleproject.sh $1
    echoe "\033[1mFinished!\033[0m"
}

alias debug="echo \"Why should you be using debug as only argument? :D \""

case "$TOOL_ARG" in
    build | buildapp | reposync | reposynclow | debug)
        $TOOL_ARG
    ;;

    envsetup);;
    
    "");;
    *)      echo "Unknown argument \"$TOOL_ARG\"."                  ;;
    
esac

logd "Cd back to beginning dir"

cd $BEGINNING_DIR

logd "Exiting script"

return 0
