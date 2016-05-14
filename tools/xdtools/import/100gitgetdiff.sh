#!/bin/bash

function repo-getdiff() {
    if [ -z "$1" ]; then
        echo "No head point specified. Please specify one. Example: HEAD~2"
        return 0
    fi
    CRTDIR="$(pwd)"
    cd $(gettop)
    echob "Searching for git repositories..."
    echo -en "\n"
    GITDIRS="$(echo -n $(find -type d -name ".git"))"
    echo -en "\n"
    echob "Now showing diff for them..."
    for gitrepo in $GITDIRS; do
        echob "Showing diff for $gitrepo"
        cd $gitrepo/../
        git diff $1
        cd $(gettop)
    done
    cd $CRTDIR
    echo "Done."
}