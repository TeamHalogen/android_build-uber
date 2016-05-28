#!/bin/bash

#
# Copyright (C) 2016 halogenOS (XOS)
#
#
# This script was originally made by xdevs23 (http://github.com/xdevs23)
# 


function xdtools_help_build() {

cat <<EOF
Usage: build <target> [lunch target] [module] [noclean]

Targets:
    full        Full ROM (bacon)
    module      Build only a specific module
    module-list Build multiple modules
    mm          Builds using mmma. Useful for frameworks or modules
                which you want to build using mmma/mmm/
    
noclean: use this option to skip cleaning before building
         this is not accepted on module-list

You have to specify the lunch target if you haven't lunched yet.
EOF

}

function xdtools_build_no_target_device() {
    
cat <<EOF
No target device specified and \$TARGET_DEVICE is 
undefined
EOF

}

function xdtools_help_reporesync() {

cat <<EOF
Usage: reporesync <option> [repository path] [repository name] [low]

Options:
    full            Full resync: delete the whole source tree, do a sync and 
                    fully resync local tree
    repo            Partial resync: only resync specified repository:
                        Deletes the specified repository from the source tree
                        and syncs it
    full-local      Full local resync: delete the whole source tree and fully resync
                    local tree
    repo-local      Partial local resync: only resync specified repository locally:
                        Deletes the specified repository from the source tree and
                        syncs it locally.
    full-x          Totally full resync: delete the whole source tree, delete all
                    repositories from .repo and does a full network resync.
                    !! WARNING: This will delete all your synced repositories and
                    !!          resync the whole source from scratch! Please make
                    !!          sure you know what you are doing!
    repo-x          Totally modular resync: Deletes the repository from source tree
                    and also removes project files and objects. This will cause
                    the repository you have specified to be completely downloaded
                    again.
    full-network    Delete the whole source tree, do a sync but don't sync work tree.
    full-network-x  Delete the whole source tree, remove all projects and objects
                    and do a full sync, but don't sync the work tree.
                
Example: reporesync repo-x packages/apps/Settings android_packages_apps_Settings
            This removes packages/apps/Settings and the repository including
            object files and project files.
        
         reporesync full
            This does a sync and resyncs the local work tree. Deletes everything
            except .repo and does a sync.
            
Additional:
    Use the low argument anywhere in the command after <option> to sync faster
    on low bandwidth.
    Example: reporesync full low
    Example: reporesynclow full

EOF

}

return 0