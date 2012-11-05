#!/bin/sh
#
# Plugin to implement a `symlink` command of the config file
#

#
# NOTE This function expect a string w/o a globbing
#
function cmd_rm()
{
    local dst="$1"
    ebegin "Removing the $dst"
    rm -rf $dst 2>/dev/null
    eend 0
    local parent=`dirname "$dst"`
    local hasSmth=`find "$parent" ! -type d`
    if [ -z "$hasSmth" ]; then
        rm -r $parent
    fi
}
