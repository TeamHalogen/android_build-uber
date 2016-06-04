#!/bin/bash

function xdtools_recleanbranch_help() {
cat <<HELP

Usage: recleanbranch <local branch> <remote branch> <remote git url> <start commit> <end commit>

Example: 
  recleanbranch XOS-6.0 LA.BF64.1.2.2_rb4.40 https://source.codeaurora.org/platform/frameworks/base \
  32f1e403d7e89d742b2c256c0845dc36d76799f2 404620776b71d70f19a36bd92e61767df56e7ed8

Note: start commit must be the commit before the first commit that should be build upon the new branch,
      otherwise you will miss the first commit!

HELP
}