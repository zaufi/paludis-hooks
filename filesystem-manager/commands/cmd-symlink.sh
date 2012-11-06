#!/bin/sh
#
# Plugin to implement a `symlink` command of the config file
#

# @param cd  -- directory to change to before making a symlink
# @param src -- source name
# @param dst -- destination name
#
function cmd_symlink()
{
    local cd="$1"
    local src="$2"
    local dst="$3"

    ebegin "Making the symlink $src --> $dst"
    if [ -d "${D}/$cd" ]; then
        cd "${D}/$cd"
        ln -s "$src" "$dst" && isSomeActionsWereTakePlace="yes"
        cd - >/dev/null
    eend $?
}
