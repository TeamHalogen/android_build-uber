#!/bin/bash

#
# Copyright (C) 2016 halogenOS (XOS)
#
#
# This script was originally made by xdevs23 (http://github.com/xdevs23)
# 


function xdtools_help_build() {

cat <<EOF
Usage: build <target> [lunch target]

Targets:
    full        Full ROM (bacon)

You have to specify the lunch target if you haven't lunched yet.
EOF

}

function xdtools_build_no_target_device() {
    
cat <<EOF
No target device specified and \$TARGET_DEVICE is 
undefined
EOF

}

return 0