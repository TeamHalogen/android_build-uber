#!/bin/bash

## Help file for 100gitgetdiff

function gitgetdiff_help_usage() {
cat <<HELP
Tool to show all changes in all repositories until the specified head position.

Usage: repo-getdiff <head>

Example: repo-getdiff HEAD~3
           Shows all changes using 'git diff' in all repositories for the last 3
           commits
HELP
}