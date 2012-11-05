#!/bin/sh
#
# Plugin to implement a `rm` command of the config file
#

#
# Function to remove smth in a given directory
#
# @param cd  -- directory to change to before remove
# @param dst -- what to remove (possible w/ wildcards)
#
function cmd_rm()
{
    local cd="$1"
    local dst="$2"
    ebegin "Removing the ${cd}/${dst}"
    cd "${D}/${cd}" \
      && rm -rf ${dst} 2>/dev/null \
      && cd -
    eend 0
    # Check if there something else in a `cd` dir?
    local hasSmth=`find "${D}/${cd}" ! -type d`
    if [ -z "${hasSmth}" ]; then
        # NO! Remove an empty dir to avoid warnings!
        rm -rf ${D}/${cd}
    fi
}
