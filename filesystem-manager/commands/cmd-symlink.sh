#!/bin/sh
#
# Plugin to implement a `symlink` command of the config file
#

function cmd_symlink()
{
    local cd="$1"
    local src="$2"
    local dst="$3"

    ebegin "Making the symlink $src --> $dst"
    cd "${D}/$cd" && ln -s "$src" "$dst" && cd -
    eend $?
}
