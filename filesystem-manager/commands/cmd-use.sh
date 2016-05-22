#!/bin/bash
#
# Plugin to implement the `use` command
#

#
# Function to check if given use flag is in action
#
# @param use -- USE flag to check
function cmd_use()
{
    local use="$1"

    local e
    for e in ${USE} xxx-dummy; do
        [[ "${e}" == "${use}" ]] && return 0
    done

    return 1
}
