#!/bin/bash

# Clean stuff
#
# Download specified CAF branch and build commits on top of it

function recleanbranch() {
    BRANCH="$1"
    REMOTEBRANCH="$2"
    REMOTEURL="$3"
    BEGINCOMMIT="$4"
    ENDCOMMIT="$5"
    
    ( [ -z "$BRANCH" ] || [ -z "$REMOTEBRANCH" ] || [ -z "$REMOTEURL" ] \
        || [ -z "$BEGINCOMMIT" ] || [ -z "$ENDCOMMIT " ] ) \
        && xdtools_recleanbranch_help && return 0
    
    echo
    echo "Local branch:   $BRANCH"
    echo "Remote branch:  $REMOTEBRANCH"
    echo "Remote git url: $REMOTEURL"
    echo
    
    sleep 1
    
    echob "Checking out local branch..."
    git checkout $BRANCH
    echob "Adding remote..."
    git remote add caf $REMOTEURL
    echob "Fetching remote..."
    git fetch caf
    echob "Moving \"$BRANCH\" to \"$BRANCH-old\"..."
    git branch --move $BRANCH-old
    echob "Checking out remote branch"
    git checkout $REMOTEBRANCH
    echob "Moving \"$REMOTEBRANCH\" to \"$BRANCH\"..."
    git branch --move $BRANCH
    echob "Building commits on top of new branch"
    git cherry-pick --ff $BEGINCOMMIT^..$ENDCOMMIT
    echob "Ready to be pushed, push using: "
    echob "git push -f --set-upstream <your remote> $BRANCH"
    echo  "If you notice that something went wrong, you can restore the old"
    echo  "branch using: "
    echo
    echo  "git branch --move $BRANCH $BRANCH-new"
    echo  "git branch --move $BRANCH-old $BRANCH"
    echo
    echo  "Then you have the new branch as $BRANCH-new and the old branch as $BRANCH"
    echo
    echob "Have fun!"
}